// Created by Mateus Lino

import CoreData
import Foundation

@testable import LeezyCoreData

@objc(MockCoreDataEntity)
final class MockCoreDataEntity: CoreDataEntity {
    @NSManaged var referenceID: String
    @NSManaged var title: String?

    var reference: MockReferenceEntity! {
        if let reference = _reference, referenceID == reference.id {
            return reference
        } else {
            _reference = Self.referenceBuilder?.entity(with: referenceID)
            return _reference
        }
    }
    fileprivate var _reference: MockReferenceEntity!
}

final class MockReferenceEntity: Entity {
    let id: String

    init(id: String = UUID().uuidString) {
        self.id = id
    }
}
