// Created by Mateus Lino

import CoreData

class LocalEntity: NSManagedObject, Entity {

    static var entityName: String {
        return String(describing: Self.self)
    }

    @NSManaged var id: String

    static func create() -> Self? {
        return localEntityBuilder?.create()
    }
}
