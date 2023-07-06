// Created by Mateus Lino

import Firebase
import FirebaseFirestoreSwift
import Foundation
import LeezyRemoteCollection

extension Firestore: RemoteCollectionDatabase {
    public func collection(named collectionPath: String) -> RemoteCollection {
        return collection(collectionPath)
    }
}

extension CollectionReference: RemoteCollection {
    public func documents() async throws -> [RemoteCollectionDocument] {
        return try await getDocuments().documents
    }
}

extension DocumentSnapshot: RemoteCollectionDocument {
    public func decoded<T: Decodable>(as type: T.Type) throws -> T  {
        return try data(as: type.self)
    }
}
