// Created by Mateus Lino

import CoreData
import Foundation
import LeezyData

public protocol CoreDataDataServiceProtocol<DataType>: DataServiceProtocol where DataType: CoreDataEntity {
    func createEmpty() -> DataType?
}

open class CoreDataDataService<T: CoreDataEntity>: DataService<T>, CoreDataDataServiceProtocol {
    typealias DataType = T

    private let managedObjectContext: NSManagedObjectContext

    public init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    override open func fetch(by id: String) async -> Result<T?, Error> {
        do {
            let predicate = NSPredicate(
                format: "id = %@", id
            )

            let values = try fetchValues(withPredicate: predicate)

            guard let value = values.first else {
                return .success(nil)
            }

            updateLatestValue(with: value)

            return await super.fetch(by: id)
        } catch {
            return .failure(error)
        }
    }

    private func fetchValues(withPredicate predicate: NSPredicate?) throws -> [T] {
        let request = T.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        return try managedObjectContext.fetch(request) as? [T] ?? []
    }

    override open func fetchAll() async -> Result<[T], Error> {
        do {
            latestValues = try fetchValues(withPredicate: nil)

            return await super.fetchAll()
        } catch {
            return .failure(error)
        }
    }

    override open func create(value: T) async -> Result<T, Error> {
        do {
            managedObjectContext.insert(value)

            try managedObjectContext.save()

            return await super.create(value: value)
        } catch {
            return .failure(error)
        }
    }

    override open func update(value: T) async -> Result<T, Error> {
        do {
            try managedObjectContext.save()

            return await super.update(value: value)
        } catch {
            return .failure(error)
        }
    }

    open func createEmpty() -> T? {
        NSEntityDescription.insertNewObject(
            forEntityName: T.entityName,
            into: managedObjectContext
        ) as? T
    }
}
