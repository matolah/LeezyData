// Created by Mateus Lino

import Foundation

@testable import LeezyRemoteCollection

struct MockRemoteEntity: RemoteEntity {
    static var collectionName = "mock-collection"

    let id: String
}

enum AnyMockRemoteEntityIdentifier: String, AnyRemoteEntityIdentifier {
    case mock

    static var collectionName = "mock-collection"

    var metatype: any RemoteEntity.Type {
        switch self {
        case .mock:
            MockRemoteEntity.self
        }
    }
}
