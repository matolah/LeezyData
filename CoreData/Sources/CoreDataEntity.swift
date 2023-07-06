// Created by Mateus Lino

import CoreData

class CoreDataEntity: NSManagedObject, Entity {
    static var referenceBuilder: ReferenceBuilderProtocol?
    static var coreDataEntityBuilder: CoreDataEntityBuilderProtocol?

    static var entityName: String {
        return String(describing: Self.self)
    }

    @NSManaged var id: String

    static func create() -> Self? {
        return coreDataEntityBuilder?.create()
    }
}
