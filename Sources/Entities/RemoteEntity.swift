// Created by Mateus Lino

import Foundation

class RemoteEntity: Entity, Decodable {
    class var remoteCollectionName: String {
        return String()
    }

    let id: String

    init(id: String) {
        self.id = id
    }

    static func == (lhs: RemoteEntity, rhs: RemoteEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
