// Created by Mateus Lino

import Combine
import Foundation

public protocol DataServiceProtocol<DataType> {
    associatedtype DataType: Entity

    var valuesSubject: CurrentValueSubject<[DataType], Error> { get }
    func fetchAll() async -> Result<[DataType], Error>
    func fetch(by id: String) async -> Result<DataType?, Error>
    func create(value: DataType) async -> Result<DataType, Error>
    func update(value: DataType) async -> Result<DataType, Error>
}

open class DataService<T: Entity>: DataServiceProtocol {
    public typealias DataType = T

    public lazy var valuesSubject = CurrentValueSubject<[DataType], Error>(latestValues)

    public var latestValues = [T]() {
        didSet {
            valuesSubject.send(latestValues)
        }
    }

    public init() {}

    open func fetchAll() async -> Result<[T], Error> {
        return .success(latestValues)
    }

    open func fetch(by id: String) async -> Result<T?, Error> {
        let value = latestValues.first { entity in
            return entity.id == id
        }
        return .success(value)
    }

    open func create(value: T) async -> Result<T, Error> {
        latestValues.append(value)
        
        return .success(value)
    }

    open func update(value: T) async -> Result<T, Error> {
        updateLatestValue(with: value)

        return .success(value)
    }

    public func updateLatestValue(with value: T) {
        if let index = latestValues.firstIndex(where: { $0.id == value.id }) {
            latestValues[index] = value
        } else {
            latestValues.append(value)
        }
    }
}
