// Created by Mateus Lino

import Foundation

public protocol RemoteCollectionDatabase {
    func collection(named collectionPath: String) -> RemoteCollection
}

public protocol RemoteCollection {
    func documents() async throws -> [RemoteCollectionDocument]
    func document(by id: String) async throws -> RemoteCollectionDocument?
    func addDocument<T: Codable>(_ value: T) async throws -> T
    func updateDocument<T: Codable>(_ value: T, id: String) async throws
}

public protocol RemoteCollectionDocument {
    func decoded<T: Decodable>(as type: T.Type) throws -> T
}

public struct MockRemoteCollectionDatabase: RemoteCollectionDatabase {
    public init() {}

    public func collection(named collectionPath: String) -> RemoteCollection {
        MockRemoteCollection()
    }
}

struct MockRemoteCollection: RemoteCollection {
    func documents() async throws -> [RemoteCollectionDocument] {
        []
    }

    func document(by id: String) async throws -> RemoteCollectionDocument? {
        nil
    }

    func addDocument<T: Codable>(_ value: T) async throws -> T {
        value
    }

    func updateDocument(_ value: some Codable, id: String) async throws {}
}
