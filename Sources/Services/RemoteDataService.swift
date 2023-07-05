// Created by Mateus Lino

import Firebase
import FirebaseFirestoreSwift
import Foundation

final class RemoteDataService<T: RemoteEntity>: DataService<T> {
    typealias DataType = T

    private let database: Firestore

    init(database: Firestore = Firestore.firestore()) {
        self.database = database
    }

    override func fetchAll() async -> Result<[T], Error> {
        let query = database
            .collection(T.remoteCollectionName)

        do {
            let querySnapshot = try await query.getDocuments()

            latestValues = try querySnapshot.documents.map {
                return try $0.data(as: T.self)
            }

            return await super.fetchAll()
        } catch {
            return .failure(error)
        }
    }

    override func create(value: T) async -> Result<T, Error> {
        return await super.create(value: value)
    }

    override func update(value: T) async -> Result<T, Error> {
        return await super.update(value: value)
    }
}
