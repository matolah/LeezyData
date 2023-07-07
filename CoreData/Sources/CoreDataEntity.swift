// Created by Mateus Lino

import CoreData
import LeezyData

open class CoreDataEntity: NSManagedObject, Entity {
    public static var referenceBuilder: ReferenceBuilderProtocol?
    public static var coreDataEntityBuilder: CoreDataEntityBuilderProtocol?

    public static var entityName: String {
        return String(describing: Self.self)
    }

    @NSManaged public var id: String

    public static func create() -> Self? {
        return coreDataEntityBuilder?.create()
    }
}
