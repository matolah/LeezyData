// Created by Mateus Lino

import Foundation

protocol DataManagerProtocol {
    func values<T: Entity>(shouldRefetch: Bool) async -> Result<[T], Error>
    func create<T: Entity>(value: T) async -> Result<T, Error>
    func update<T: Entity>(value: T) async -> Result<T, Error>
}

protocol ReferenceBuilderProtocol {
    func entity<T: Entity>(with id: String) -> T?
}

protocol LocalEntityBuilderProtocol {
    func create<T: LocalEntity>() -> T?
}

enum DataManagementError: Error {
    case serviceNotFound
}

final class DataManager: ObservableObject, DataManagerProtocol, ReferenceBuilderProtocol, LocalEntityBuilderProtocol {
    private let dataServices: [any DataServiceProtocol]

    init(dataServices: [any DataServiceProtocol]) {
        self.dataServices = dataServices
    }

    func values<T: Entity>(shouldRefetch: Bool) async -> Result<[T], Error> {
        guard let dataService = dataService(T.self) else {
            return .failure(DataManagementError.serviceNotFound)
        }

        if shouldRefetch {
            return await dataService.fetchAll()
        } else {
            return .success(dataService.latestValues)
        }
    }

    func create<T: Entity>(value: T) async -> Result<T, Error> {
        guard let dataService = dataService(T.self) else {
            return .failure(DataManagementError.serviceNotFound)
        }

        return await dataService.create(value: value)
    }

    func update<T: Entity>(value: T) async -> Result<T, Error> {
        guard let dataService = dataService(T.self) else {
            return .failure(DataManagementError.serviceNotFound)
        }

        return await dataService.update(value: value)
    }

    func entity<T: Entity>(with id: String) -> T? {
        let dataService = dataService(T.self)
        return dataService?.latestValues.first(where: {
            $0.id == id
        })
    }

    private func dataService<T: Entity>(_ entityType: T.Type) -> (any DataServiceProtocol<T>)? {
        return dataServices.first(where: {
            return $0 is any DataServiceProtocol<T>
        }) as? any DataServiceProtocol<T>
    }

    func create<T: LocalEntity>() -> T? {
        guard let dataService = dataService(T.self) as? any LocalDataServiceProtocol<T>,
              let newValue = dataService.createEmpty() else {
            return nil
        }
        newValue.id = UUID().uuidString
        return newValue as? T
    }
}
