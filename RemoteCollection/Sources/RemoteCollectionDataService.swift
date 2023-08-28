// Created by Mateus Lino

import Foundation
import LeezyData

open class RemoteCollectionDataService<T: RemoteEntity>: DataService<T> {
    typealias DataType = T

    private let database: RemoteCollectionDatabase

    public init(database: RemoteCollectionDatabase) {
        self.database = database
    }

    open override func fetchAll() async -> Result<[T], Error> {
        do {
            latestValues = try await collection().documents().map {
                return try $0.decoded(as: T.self)
            }

            return await super.fetchAll()
        } catch {
            return .failure(error)
        }
    }

    open override func fetch(by id: String) async -> Result<T?, Error> {
        do {
            guard let value = try await collection().document(by: id)?.decoded(as: T.self) else {
                return .success(nil)
            }

            updateLatestValue(with: value)

            return await super.fetch(by: id)
        } catch {
            return .failure(error)
        }
    }

    private func collection() -> RemoteCollection {
        return database
            .collection(named: T.collectionName)
    }

    open override func create(value: T) async -> Result<T, Error> {
        do {
            let value = try await collection().addDocument(value)

            return await super.create(value: value)
        } catch {
            return .failure(error)
        }
    }

    open override func update(value: T) async -> Result<T, Error> {
        do {
            try await collection().updateDocument(value, id: value.id)

            return await super.update(value: value)
        } catch {
            return .failure(error)
        }
    }
}
