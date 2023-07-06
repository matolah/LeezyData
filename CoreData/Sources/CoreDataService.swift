// Created by Mateus Lino

import CoreData
import Foundation
import LeezyData

protocol CoreDataDataServiceProtocol<DataType>: DataServiceProtocol where DataType: CoreDataEntity {
    func createEmpty() -> DataType?
}

final class CoreDataDataService<T: CoreDataEntity>: DataService<T>, CoreDataDataServiceProtocol {
    typealias DataType = T

    let managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    override func fetchAll() async -> Result<[T], Error> {
        let request = T.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            latestValues = try managedObjectContext.fetch(request) as? [T] ?? []

            return await super.fetchAll()
        } catch {
            return .failure(error)
        }
    }

    override func create(value: T) async -> Result<T, Error> {
        do {
            managedObjectContext.insert(value)

            try managedObjectContext.save()

            latestValues.append(value)

            return await super.create(value: value)
        } catch {
            return .failure(error)
        }
    }

    override func update(value: T) async -> Result<T, Error> {
        do {
            try managedObjectContext.save()

            if let index = latestValues.firstIndex(where: { $0.id == value.id }) {
                latestValues[index] = value
            }

            return await super.update(value: value)
        } catch {
            return .failure(error)
        }
    }

    func createEmpty() -> T? {
        return NSEntityDescription.insertNewObject(
            forEntityName: T.entityName,
            into: managedObjectContext
        ) as? T
    }
}
