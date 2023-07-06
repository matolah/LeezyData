// Created by Mateus Lino

import Foundation

public protocol RemoteCollectionDatabase {
    func collection(named collectionPath: String) -> RemoteCollection
}

public protocol RemoteCollection {
    func documents() async throws -> [RemoteCollectionDocument]
}

public protocol RemoteCollectionDocument {
    func decoded<T: Decodable>(as type: T.Type) throws -> T
}
