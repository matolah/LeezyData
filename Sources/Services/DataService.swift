// Created by Mateus Lino

import Foundation

protocol DataServiceProtocol<DataType> {
    associatedtype DataType: Entity

    var latestValues: [DataType] { get }
    func fetchAll() async -> Result<[DataType], Error>
    func create(value: DataType) async -> Result<DataType, Error>
    func update(value: DataType) async -> Result<DataType, Error>
}

class DataService<T: Entity>: DataServiceProtocol {
    typealias DataType = T

    var latestValues = [T]()

    func fetchAll() async -> Result<[T], Error> {
        return .success(latestValues)
    }

    func create(value: T) async -> Result<T, Error> {
        latestValues.append(value)
        return .success(value)
    }

    func update(value: T) async -> Result<T, Error> {
        if let index = latestValues.firstIndex(where: { $0.id == value.id }) {
            latestValues[index] = value
        }

        return .success(value)
    }
}
