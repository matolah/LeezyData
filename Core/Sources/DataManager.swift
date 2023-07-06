// Created by Mateus Lino

import Foundation

public protocol DataManagerProtocol {
    func values<T: Entity>(shouldRefetch: Bool) async -> Result<[T], Error>
    func create<T: Entity>(value: T) async -> Result<T, Error>
    func update<T: Entity>(value: T) async -> Result<T, Error>
}

public protocol ReferenceBuilderProtocol {
    func entity<T: Entity>(with id: String) -> T?
}

enum DataManagementError: Error {
    case serviceNotFound
}

public final class DataManager: ObservableObject, DataManagerProtocol, ReferenceBuilderProtocol {
    let dataServices: [any DataServiceProtocol]

    public init(dataServices: [any DataServiceProtocol]) {
        self.dataServices = dataServices
    }

    public func values<T: Entity>(shouldRefetch: Bool) async -> Result<[T], Error> {
        guard let dataService = dataService(T.self) else {
            return .failure(DataManagementError.serviceNotFound)
        }

        if shouldRefetch {
            return await dataService.fetchAll()
        } else {
            return .success(dataService.latestValues)
        }
    }

    func dataService<T: Entity>(_ entityType: T.Type) -> (any DataServiceProtocol<T>)? {
        for dataService in dataServices {
            if let match = dataService as? any DataServiceProtocol<T> {
                return match
            }
        }
        return nil
    }

    public func create<T: Entity>(value: T) async -> Result<T, Error> {
        guard let dataService = dataService(T.self) else {
            return .failure(DataManagementError.serviceNotFound)
        }

        return await dataService.create(value: value)
    }

    public func update<T: Entity>(value: T) async -> Result<T, Error> {
        guard let dataService = dataService(T.self) else {
            return .failure(DataManagementError.serviceNotFound)
        }

        return await dataService.update(value: value)
    }

    public func entity<T: Entity>(with id: String) -> T? {
        let dataService = dataService(T.self)
        return dataService?.latestValues.first(where: {
            $0.id == id
        })
    }
}
