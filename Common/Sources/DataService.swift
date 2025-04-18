// Created by Mateus Lino

import Combine
import Foundation

public protocol DataServiceProtocol<DataType> {
    associatedtype DataType: Entity

    var valuesSubject: CurrentValueSubject<[DataType], Error> { get }
    func fetch(by id: String) async -> Result<DataType?, Error>
    func fetchAll() async -> Result<[DataType], Error>
    func create(value: DataType) async -> Result<DataType, Error>
    func update(value: DataType) async -> Result<DataType, Error>
}

open class DataService<T: Entity>: DataServiceProtocol {
    public typealias DataType = T

    private var _latestValues = [T]()
    private let queue = DispatchQueue(label: "dataservice.queue.\(UUID())", attributes: .concurrent)
    public lazy var valuesSubject = CurrentValueSubject<[DataType], Error>(_latestValues)

    public var latestValues: [T] {
        get {
            queue.sync {
                _latestValues
            }
        }
        set {
            queue.async(flags: .barrier) { [weak self] in
                self?._latestValues = newValue
                self?.valuesSubject.send(newValue)
            }
        }
    }

    public init() {}

    open func fetch(by id: String) async -> Result<T?, Error> {
        let value = latestValues.first { entity in
            entity.id == id
        }
        return .success(value)
    }

    open func fetchAll() async -> Result<[T], Error> {
        .success(latestValues)
    }

    open func create(value: T) async -> Result<T, Error> {
        updateLatestValue(with: value)
        return .success(value)
    }

    public func updateLatestValue(with value: T) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else {
                return
            }

            let index = self._latestValues.firstIndex(where: { $0.id == value.id })
            if let index {
                self._latestValues[index] = value
            } else {
                self._latestValues.append(value)
            }

            self.valuesSubject.send(self._latestValues)
        }
    }

    open func update(value: T) async -> Result<T, Error> {
        updateLatestValue(with: value)
        return .success(value)
    }
}
