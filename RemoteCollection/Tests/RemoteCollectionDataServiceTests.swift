// Created by Mateus Lino

import XCTest

@testable import LeezyRemoteCollection

final class RemoteCollectionDataServiceTests: XCTestCase {
    private var dataService: RemoteCollectionDataService<AnyRemoteEntity<AnyMockRemoteEntityIdentifier>>!
    private var databaseSpy: RemoteCollectionDatabaseSpy!

    override func setUp() {
        super.setUp()

        databaseSpy = RemoteCollectionDatabaseSpy()
        dataService = RemoteCollectionDataService(database: databaseSpy)
    }

    override func tearDown() {
        dataService = nil
        databaseSpy = nil

        super.tearDown()
    }

    func test_fetchAll_whenFetchIsSuccessful_shouldReturnValues() async {
        let collection = RemoteCollectionSpy()
        let document = MockRemoteCollectionDocument()
        let entity = MockRemoteEntity(id: "")
        let anyEntity = AnyRemoteEntity<AnyMockRemoteEntityIdentifier>(value: entity)
        document.decodedToReturn = anyEntity
        collection.documentsToReturn = [document]
        databaseSpy.remoteCollectionToReturn = collection

        let result = await dataService.fetchAll()

        XCTAssertTrue(databaseSpy.collectionCalled)
        switch result {
        case .success(let values):
            XCTAssertEqual(values, [anyEntity])
            XCTAssertEqual(values, dataService.latestValues)
        case .failure:
            XCTFail()
        }
    }

    func test_fetchAll_whenFetchFailed_shouldReturnError() async {
        let collection = RemoteCollectionSpy()
        collection.shouldReturnError = true
        databaseSpy.remoteCollectionToReturn = collection

        let result = await dataService.fetchAll()

        XCTAssertTrue(databaseSpy.collectionCalled)
        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertTrue(error is RemoteCollectionError)
        }
    }

    func test_fetchById_whenEntityExists_shouldReturnEntity() async {
        let collection = RemoteCollectionSpy()
        let document = MockRemoteCollectionDocument()
        let entity = MockRemoteEntity(id: "mock123")
        let anyEntity = AnyRemoteEntity<AnyMockRemoteEntityIdentifier>(value: entity)
        document.decodedToReturn = anyEntity
        collection.documentToReturn = document
        databaseSpy.remoteCollectionToReturn = collection

        let result = await dataService.fetch(by: "mock123")

        XCTAssertTrue(databaseSpy.collectionCalled)
        switch result {
        case .success(let value):
            XCTAssertEqual(value, anyEntity)
        case .failure:
            XCTFail()
        }
    }

    func test_fetchById_whenEntityDoesNotExist_shouldReturnNil() async {
        let collection = RemoteCollectionSpy()
        databaseSpy.remoteCollectionToReturn = collection

        let result = await dataService.fetch(by: "nonexistent_id")

        XCTAssertTrue(databaseSpy.collectionCalled)
        switch result {
        case .success(let value):
            XCTAssertNil(value)
        case .failure:
            XCTFail()
        }
    }

    func test_fetchById_whenFetchFails_shouldReturnError() async {
        let collection = RemoteCollectionSpy()
        collection.shouldReturnError = true
        databaseSpy.remoteCollectionToReturn = collection

        let result = await dataService.fetch(by: "mock123")

        XCTAssertTrue(databaseSpy.collectionCalled)
        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertTrue(error is RemoteCollectionError)
        }
    }

    func test_create_whenCreationIsSuccessful_shouldReturnValue() async {
        let collection = RemoteCollectionSpy()
        let entity = MockRemoteEntity(id: "")
        let anyEntity = AnyRemoteEntity<AnyMockRemoteEntityIdentifier>(value: entity)
        collection.valueToReturn = anyEntity
        databaseSpy.remoteCollectionToReturn = collection

        let result = await dataService.create(value: anyEntity)

        XCTAssertTrue(databaseSpy.collectionCalled)
        XCTAssertTrue(collection.addDocumentCalled)
        switch result {
        case .success(let value):
            XCTAssertEqual(value, anyEntity)
            XCTAssertEqual(dataService.latestValues, [anyEntity])
        case .failure:
            XCTFail()
        }
    }

    func test_create_whenCreationFailed_shouldReturnError() async {
        let collection = RemoteCollectionSpy()
        let entity = MockRemoteEntity(id: "")
        let anyEntity = AnyRemoteEntity<AnyMockRemoteEntityIdentifier>(value: entity)
        collection.shouldReturnError = true
        collection.valueToReturn = anyEntity
        databaseSpy.remoteCollectionToReturn = collection

        let result = await dataService.create(value: anyEntity)

        XCTAssertTrue(databaseSpy.collectionCalled)
        XCTAssertTrue(collection.addDocumentCalled)
        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertTrue(error is RemoteCollectionError)
        }
    }

    func test_update_whenUpdateIsSuccessful_shouldReturnValue() async {
        let collection = RemoteCollectionSpy()
        let entity = MockRemoteEntity(id: "mock123")
        let anyEntity = AnyRemoteEntity<AnyMockRemoteEntityIdentifier>(value: entity)
        collection.valueToReturn = anyEntity
        databaseSpy.remoteCollectionToReturn = collection
        dataService.latestValues = [anyEntity]

        let result = await dataService.update(value: anyEntity)

        XCTAssertTrue(databaseSpy.collectionCalled)
        XCTAssertTrue(collection.updateDocumentCalled)
        switch result {
        case .success(let value):
            XCTAssertEqual(value, anyEntity)
            XCTAssertEqual(dataService.latestValues, [anyEntity])
        case .failure:
            XCTFail()
        }
    }

    func test_update_whenUpdateFailed_shouldReturnError() async {
        let collection = RemoteCollectionSpy()
        let entity = MockRemoteEntity(id: "mock123")
        let anyEntity = AnyRemoteEntity<AnyMockRemoteEntityIdentifier>(value: entity)
        collection.shouldReturnError = true
        collection.valueToReturn = anyEntity
        databaseSpy.remoteCollectionToReturn = collection

        let result = await dataService.update(value: anyEntity)

        XCTAssertTrue(databaseSpy.collectionCalled)
        XCTAssertTrue(collection.updateDocumentCalled)
        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertTrue(error is RemoteCollectionError)
        }
    }
}
