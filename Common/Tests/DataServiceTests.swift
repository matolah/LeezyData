// Created by Mateus Lino

import Combine
import XCTest

@testable import LeezyData

final class DataServiceTests: XCTestCase {
    private var dataService: DataService<MockEntity>!

    override func setUp() {
        super.setUp()
        dataService = DataService()
    }

    override func tearDown() {
        dataService = nil
        super.tearDown()
    }

    func test_fetchAll() async {
        let entity = MockEntity(id: "mock")
        dataService.latestValues = [entity]

        let result = await dataService.fetchAll()

        switch result {
        case let .success(values):
            XCTAssertEqual(values, [entity])
            XCTAssertEqual(dataService.latestValues, [entity])
            XCTAssertEqual(dataService.valuesSubject.value, [entity])
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }

    func test_fetchByID_whenEntityExists() async {
        let entity = MockEntity(id: "mock")
        dataService.latestValues = [entity]

        let result = await dataService.fetch(by: "mock")

        switch result {
        case let .success(fetchedEntity):
            XCTAssertEqual(fetchedEntity, entity)
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }

    func test_fetchByID_whenEntityDoesNotExist() async {
        let entity = MockEntity(id: "mock")
        dataService.latestValues = [entity]

        let result = await dataService.fetch(by: "nonexistent_id")

        switch result {
        case let .success(fetchedEntity):
            XCTAssertNil(fetchedEntity)
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }

    func test_create() async {
        let entity1 = MockEntity(id: "mock")
        dataService.latestValues = [entity1]

        XCTAssertEqual(dataService.latestValues, [entity1])
        XCTAssertEqual(dataService.valuesSubject.value, [entity1])

        let entity2 = MockEntity(id: "mock_2")
        let result = await dataService.create(value: entity2)

        switch result {
        case let .success(value):
            XCTAssertEqual(value, entity2)
            XCTAssertEqual(dataService.latestValues, [entity1, entity2])
            XCTAssertEqual(dataService.valuesSubject.value, [entity1, entity2])
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }

    func test_update_whenEntityExists() async {
        let entity = MockEntity(id: "mock", name: "Old Name")
        dataService.latestValues = [entity]

        let updatedEntity = MockEntity(id: "mock", name: "New Name")
        let result = await dataService.update(value: updatedEntity)

        switch result {
        case let .success(value):
            XCTAssertEqual(value, updatedEntity)
            XCTAssertEqual(dataService.latestValues, [updatedEntity])
            XCTAssertEqual(dataService.valuesSubject.value, [updatedEntity])
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }

    func test_update_whenEntityDoesNotExist() async {
        let entity = MockEntity(id: "mock", name: "New Entry")
        let result = await dataService.update(value: entity)

        switch result {
        case let .success(value):
            XCTAssertEqual(value, entity)
            XCTAssertEqual(dataService.latestValues, [entity])
            XCTAssertEqual(dataService.valuesSubject.value, [entity])
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }
}
