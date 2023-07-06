// Created by Mateus Lino

import Foundation

public protocol DataServiceProtocol<DataType> {
    associatedtype DataType: Entity

    var latestValues: [DataType] { get }
    func fetchAll() async -> Result<[DataType], Error>
    func create(value: DataType) async -> Result<DataType, Error>
    func update(value: DataType) async -> Result<DataType, Error>
}

open class DataService<T: Entity>: DataServiceProtocol {
    public typealias DataType = T

    public var latestValues = [T]()

    public init() {}

    open func fetchAll() async -> Result<[T], Error> {
        return .success(latestValues)
    }

    open func create(value: T) async -> Result<T, Error> {
        latestValues.append(value)
        return .success(value)
    }

    open func update(value: T) async -> Result<T, Error> {
        if let index = latestValues.firstIndex(where: { $0.id == value.id }) {
            latestValues[index] = value
        }

        return .success(value)
    }
}
