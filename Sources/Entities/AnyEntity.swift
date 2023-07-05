// Created by Mateus Lino

import Foundation
import Foundation

typealias DecodableEntity = Entity & Decodable

protocol AnyEntityIdentifier {
    var metatype: any DecodableEntity.Type { get }
    init?(rawValue: String)
}

final class AnyEntity<Identifier: AnyEntityIdentifier>: Entity, Decodable {
    private enum CodingKeys: String, CodingKey {
        case identifier
        case content
    }

    let value: any Entity

    var id: String {
        return value.id
    }

    init(value: any Entity) {
        self.value = value
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let identifier = try container.decode(String.self, forKey: .identifier)
        guard let metatype = Identifier(rawValue: identifier)?.metatype else {
            throw EntityCreationError.decodingFailed
        }
        let value = try metatype.init(from: decoder)
        self.init(value: value)
    }

    static func == (lhs: AnyEntity<Identifier>, rhs: AnyEntity<Identifier>) -> Bool {
        return lhs.id == rhs.id
    }
}
