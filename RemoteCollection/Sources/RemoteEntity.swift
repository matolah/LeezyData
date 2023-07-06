// Created by Mateus Lino

import Foundation

struct EntityDecodingFailed: Error {}

public protocol RemoteEntity: Entity, Decodable {
    static var collectionName: String { get }
}

public protocol AnyRemoteEntityIdentifier {
    static var collectionName: String { get }
    var metatype: any RemoteEntity.Type { get }
    init?(rawValue: String)
}

public final class AnyRemoteEntity<Identifier: AnyRemoteEntityIdentifier>: RemoteEntity {
    private enum CodingKeys: String, CodingKey {
        case identifier
        case content
    }

    public static var collectionName: String {
        return Identifier.collectionName
    }

    public let value: any RemoteEntity

    public var id: String {
        return value.id
    }

    public init(value: any RemoteEntity) {
        self.value = value
    }

    convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let identifier = try container.decode(String.self, forKey: .identifier)
        guard let metatype = Identifier(rawValue: identifier)?.metatype else {
            throw EntityDecodingFailed()
        }
        let value = try metatype.init(from: decoder)
        self.init(value: value)
    }

    public static func == (lhs: AnyRemoteEntity<Identifier>, rhs: AnyRemoteEntity<Identifier>) -> Bool {
        return lhs.id == rhs.id
    }
}

