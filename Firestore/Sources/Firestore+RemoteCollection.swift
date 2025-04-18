// Created by Mateus Lino

import Firebase
import FirebaseFirestore
import Foundation
import LeezyRemoteCollection

extension Firestore: RemoteCollectionDatabase {
    public func collection(named collectionPath: String) -> RemoteCollection {
        collection(collectionPath)
    }
}

extension CollectionReference: RemoteCollection {
    public func documents() async throws -> [RemoteCollectionDocument] {
        try await getDocuments().documents
    }

    public func document(by id: String) async throws -> RemoteCollectionDocument? {
        try await document(id).getDocument()
    }

    public func addDocument<T: Codable>(_ value: T) async throws -> T {
        try await addDocument(data: value.dictionary)
            .getDocument()
            .decoded(as: T.self)
    }

    public func updateDocument(_ value: some Codable, id: String) async throws {
        try await document(id).updateData(value.trimmedNilDictionary)
    }
}

extension DocumentSnapshot: RemoteCollectionDocument {
    public func decoded<T: Decodable>(as type: T.Type) throws -> T {
        try data(as: type.self)
    }
}
