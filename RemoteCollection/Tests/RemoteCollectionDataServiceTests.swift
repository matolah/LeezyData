// Created by Mateus Lino

import XCTest

@testable import LeezyData

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
}
