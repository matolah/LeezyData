// Created by Mateus Lino

import CoreData
import Foundation

@testable import LeezyData

enum AnyMockEntityIdentifier: String, AnyEntityIdentifier, CaseIterable {
    case local = "local"
    case remote = "remote"

    var metatype: any DecodableEntity.Type {
        switch self {
        case .local:
            return LocalMockEntity.self
        case .remote:
            return RemoteMockEntity.self
        }
    }
}

final class LocalMockEntity: LocalEntity, MockEntity, Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
    }

    @NSManaged var referenceID: String

    var reference: RemoteMockEntity! {
        if let reference = _reference, referenceID == reference.id {
            return reference
        } else {
            let anyReference: AnyEntity<AnyMockEntityIdentifier>? = Self.referenceBuilder?.entity(with: referenceID)
            _reference = anyReference?.value as? RemoteMockEntity
            return _reference
        }
    }
    fileprivate var _reference: RemoteMockEntity!

    convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKey = CodingUserInfoKey.managedObjectContext,
              let context = decoder.userInfo[codingUserInfoKey] as? NSManagedObjectContext else {
            throw EntityCreationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
    }
}

protocol MockEntity: Entity {
    init(from decoder: Decoder) throws
}

final class RemoteMockEntity: RemoteEntity, MockEntity {
    override init(id: String) {
        super.init(id: id)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
