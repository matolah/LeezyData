// Created by Mateus Lino

import Foundation

@testable import LeezyData

class MockEntity: Entity, Decodable {
    var id: String

    init(id: String) {
        self.id = id
    }

    static func == (lhs: MockEntity, rhs: MockEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
