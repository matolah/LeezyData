// Created by Mateus Lino

import Foundation
import LeezyData

final class RemoteCollectionDataService<T: RemoteEntity>: DataService<T> {
    typealias DataType = T

    private let database: RemoteCollectionDatabase

    init(database: RemoteCollectionDatabase) {
        self.database = database
    }

    override func fetchAll() async -> Result<[T], Error> {
        let collection = database
            .collection(named: T.collectionName)

        do {
            latestValues = try await collection.documents().map {
                return try $0.decoded(as: T.self)
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
