// Created by Mateus Lino

import Foundation

@testable import LeezyData

class MockEntity: Entity, Decodable {
    var id: String

    init(id: String = UUID().uuidString) {
        self.id = id
    }
}
