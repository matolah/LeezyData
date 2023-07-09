// Created by Mateus Lino

import Foundation

@testable import LeezyRemoteCollection

struct RemoteCollectionError: Error {}

final class RemoteCollectionDatabaseSpy: RemoteCollectionDatabase {
    private(set) var collectionCalled = false
    private(set) var collectionPathPassed: String?
    var remoteCollectionToReturn: (any RemoteCollection)!

    func collection(named collectionPath: String) -> any RemoteCollection {
        collectionCalled = true
        collectionPathPassed = collectionPath
        return remoteCollectionToReturn
    }
}

final class RemoteCollectionSpy: RemoteCollection {
    private(set) var documentsCalled = false
    var shouldReturnError = false
    var documentsToReturn = [any RemoteCollectionDocument]()
    private(set) var addDocumentCalled = false
    private(set) var valuePassed: (any Codable)?
    var valueToReturn: (any Codable)!
    private(set) var updateDocumentCalled = false
    private(set) var idPassed: String?

    func documents() async throws -> [RemoteCollectionDocument] {
        documentsCalled = true
        if shouldReturnError {
            throw RemoteCollectionError()
        }
        return documentsToReturn
    }

    func addDocument<T: Codable>(_ value: T) async throws -> T {
        addDocumentCalled = true
        valuePassed = value
        if shouldReturnError {
            throw RemoteCollectionError()
        }
        return valueToReturn as! T
    }

    func updateDocument<T: Codable>(_ value: T, id: String) async throws {
        updateDocumentCalled = true
        valuePassed = value
        idPassed = id
        if shouldReturnError {
            throw RemoteCollectionError()
        }
    }
}

final class MockRemoteCollectionDocument: RemoteCollectionDocument {
    private(set) var documentsCalled = false
    var decodedToReturn: (any Decodable)!

    func decoded<T: Decodable>(as type: T.Type) throws -> T {
        return decodedToReturn as! T
    }
}
