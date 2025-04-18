// Created by Mateus Lino

import Foundation
import LeezyData

struct EntityDecodingFailed: Error {}

struct EntityEncodingFailed: Error {}

public protocol RemoteEntity: Entity, Codable {
    static var collectionName: String { get }
}

public protocol AnyRemoteEntityIdentifier: CaseIterable {
    static var collectionName: String { get }
    var rawValue: String { get }
    var metatype: any RemoteEntity.Type { get }
    init?(rawValue: String)
}

public final class AnyRemoteEntity<Identifier: AnyRemoteEntityIdentifier>: RemoteEntity {
    private enum CodingKeys: String, CodingKey {
        case identifier
    }

    public static var collectionName: String {
        Identifier.collectionName
    }

    public let value: any RemoteEntity

    public var id: String {
        value.id
    }

    public init(value: any RemoteEntity) {
        self.value = value
    }

    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let identifier = try container.decode(String.self, forKey: .identifier)
        guard let metatype = Identifier(rawValue: identifier)?.metatype else {
            throw EntityDecodingFailed()
        }
        let value = try metatype.init(from: decoder)
        self.init(value: value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let identifier = Identifier.allCases.first {
            $0.metatype == type(of: value)
        }
        guard let identifier else {
            throw EntityEncodingFailed()
        }
        try container.encode(identifier.rawValue, forKey: .identifier)
        try value.encode(to: encoder)
    }
}
