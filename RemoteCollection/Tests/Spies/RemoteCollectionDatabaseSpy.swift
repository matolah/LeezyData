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

    func documents() async throws -> [RemoteCollectionDocument] {
        documentsCalled = true
        if shouldReturnError {
            throw RemoteCollectionError()
        }
        return documentsToReturn
    }
}

final class MockRemoteCollectionDocument: RemoteCollectionDocument {
    private(set) var documentsCalled = false
    var decodedToReturn: (any Decodable)!

    func decoded<T: Decodable>(as type: T.Type) throws -> T {
        return decodedToReturn as! T
    }
}
