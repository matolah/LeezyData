// Created by Mateus Lino

import Foundation
import LeezyData

public final class RemoteCollectionDataService<T: RemoteEntity>: DataService<T> {
    typealias DataType = T

    private let database: RemoteCollectionDatabase

    public init(database: RemoteCollectionDatabase) {
        self.database = database
    }

    public override func fetchAll() async -> Result<[T], Error> {
        do {
            latestValues = try await collection().documents().map {
                return try $0.decoded(as: T.self)
            }

            return await super.fetchAll()
        } catch {
            return .failure(error)
        }
    }

    private func collection() -> RemoteCollection {
        return database
            .collection(named: T.collectionName)
    }

    public override func create(value: T) async -> Result<T, Error> {
        do {
            let value = try await collection().addDocument(value)

            return await super.create(value: value)
        } catch {
            return .failure(error)
        }
    }

    public override func update(value: T) async -> Result<T, Error> {
        do {
            try await collection().updateDocument(value, id: value.id)

            return await super.update(value: value)
        } catch {
            return .failure(error)
        }
    }
}
