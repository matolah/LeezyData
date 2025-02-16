// Created by Mateus Lino

import Foundation

@testable import LeezyData

class MockEntity: Entity, Decodable {
    var id: String
    var name: String

    init(id: String = UUID().uuidString, name: String = "") {
        self.id = id
        self.name = name
    }
}
