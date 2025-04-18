// Created by Mateus Lino

import Combine
import Foundation

public protocol DataManagerProtocol {
    @discardableResult func create<T: Entity>(value: T) async -> Result<T, Error>
    @discardableResult func refreshValues<T: Entity>() async -> Result<[T], Error>
    @discardableResult func update<T: Entity>(value: T) async -> Result<T, Error>
    func valuesSubject<T: Entity>() -> CurrentValueSubject<[T], Error>
}

public protocol ReferenceBuilderProtocol {
    func entity<T: Entity>(with id: String) -> T?
}

enum DataManagementError: Error {
    case serviceNotFound
}

public final class DataManager: ObservableObject, DataManagerProtocol, ReferenceBuilderProtocol {
    public let dataServices: [any DataServiceProtocol]

    public init(dataServices: [any DataServiceProtocol]) {
        self.dataServices = dataServices
    }

    public func create<T: Entity>(value: T) async -> Result<T, Error> {
        guard let dataService = dataService(T.self) else {
            return .failure(DataManagementError.serviceNotFound)
        }
        return await dataService.create(value: value)
    }

    public func refreshValues<T: Entity>() async -> Result<[T], Error> {
        guard let dataService = dataService(T.self) else {
            return .failure(DataManagementError.serviceNotFound)
        }
        return await dataService.fetchAll()
    }

    public func update<T: Entity>(value: T) async -> Result<T, Error> {
        guard let dataService = dataService(T.self) else {
            return .failure(DataManagementError.serviceNotFound)
        }
        return await dataService.update(value: value)
    }

    public func dataService<T: Entity>(_ entityType: T.Type) -> (any DataServiceProtocol<T>)? {
        for dataService in dataServices {
            if let match = dataService as? any DataServiceProtocol<T> {
                return match
            }
        }
        return nil
    }

    public func valuesSubject<T: Entity>() -> CurrentValueSubject<[T], Error> {
        guard let dataService = dataService(T.self) else {
            let subject = CurrentValueSubject<[T], Error>([])
            subject.send(completion: .failure(DataManagementError.serviceNotFound))
            return subject
        }
        return dataService.valuesSubject
    }

    public func entity<T: Entity>(with id: String) -> T? {
        let dataService = dataService(T.self)
        return dataService?.valuesSubject.value.first { value in
            value.id == id
        }
    }
}
