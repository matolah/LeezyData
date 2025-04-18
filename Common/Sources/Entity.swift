// Created by Mateus Lino

import Foundation

public protocol Entity: Equatable {
    var id: String { get }
}

public extension Entity {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
