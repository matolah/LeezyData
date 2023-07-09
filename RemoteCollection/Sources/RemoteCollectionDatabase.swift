// Created by Mateus Lino

import Foundation

public protocol RemoteCollectionDatabase {
    func collection(named collectionPath: String) -> RemoteCollection
}

public protocol RemoteCollection {
    func documents() async throws -> [RemoteCollectionDocument]
    func addDocument<T: Codable>(_ value: T) async throws -> T
    func updateDocument<T: Codable>(_ value: T, id: String) async throws
}

public protocol RemoteCollectionDocument {
    func decoded<T: Decodable>(as type: T.Type) throws -> T
}
