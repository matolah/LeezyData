// Created by Mateus Lino

import Combine
import XCTest

@testable import LeezyData

final class DataManagerTests: XCTestCase {
    private var dataManager: DataManager!
    private var dataServiceSpy: DataServiceSpy<MockEntity>!

    override func setUp() {
        super.setUp()

        dataServiceSpy = DataServiceSpy()
        dataManager = DataManager(dataServices: [dataServiceSpy])
    }

    override func tearDown() {
        dataManager = nil
        dataServiceSpy = nil

        super.tearDown()
    }

    func test_valuesSubject_shouldReturnSubjectWithLatestLocalValues() async {
        let mockEntity = MockEntity()
        dataServiceSpy.valuesSubject.send([mockEntity])

        let subject: CurrentValueSubject<[MockEntity], Error> = dataManager.valuesSubject()

        XCTAssertEqual(subject.value, [mockEntity])
    }

    func test_refreshValues_shouldReturnLatestLocalValues() async {
        let mockEntity = MockEntity()
        dataServiceSpy.entitiesResultToReturn = .success([mockEntity])

        let result: Result<[MockEntity], Error> = await dataManager.refreshValues()

        switch result {
        case .success(let values):
            XCTAssertTrue(dataServiceSpy.fetchAllCalled)
            XCTAssertEqual(values, [mockEntity])
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func test_values_whenDataServiceIsInvalid_shouldReturnError() async {
        dataManager = DataManager(dataServices: [])

        let result: Result<[MockEntity], Error> = await dataManager.refreshValues()

        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertTrue(error as? DataManagementError == DataManagementError.serviceNotFound)
        }
    }

    func test_create_whenCreatedSuccessfully_shouldReturnCreatedEntity() async {
        let mockEntity = MockEntity()
        dataServiceSpy.entityResultToReturn = .success(mockEntity)

        let result = await dataManager.create(value: mockEntity)

        switch result {
        case .success(let value):
            XCTAssertTrue(dataServiceSpy.createCalled)
            XCTAssertEqual(value, mockEntity)
        case .failure:
            XCTFail()
        }
    }

    func test_create_whenDataServiceIsInvalid_shouldReturnError() async {
        dataManager = DataManager(dataServices: [])

        let result = await dataManager.create(value: MockEntity())

        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertTrue(error as? DataManagementError == DataManagementError.serviceNotFound)
        }
    }

    func test_update_whenUpdatedSuccessfully_shouldReturnUpdatedEntity() async {
        let mockEntity = MockEntity()
        dataServiceSpy.entityResultToReturn = .success(mockEntity)

        let result = await dataManager.update(value: mockEntity)

        switch result {
        case .success(let value):
            XCTAssertTrue(dataServiceSpy.updateCalled)
            XCTAssertEqual(value, mockEntity)
        case .failure:
            XCTFail()
        }
    }

    func test_update_whenDataServiceIsInvalid_shouldReturnError() async {
        dataManager = DataManager(dataServices: [])

        let result = await dataManager.update(value: MockEntity())

        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertTrue(error as? DataManagementError == DataManagementError.serviceNotFound)
        }
    }

    func test_entity_whenFoundMatch_shouldReturnMatchedEntity() async {
        let entity1 = MockEntity()
        let entity2 = MockEntity()
        dataServiceSpy.valuesSubject.send([entity1, entity2])

        XCTAssertEqual(dataManager.entity(with: entity2.id), entity2)
    }

    func test_entity_whenThereIsNoMatch_shouldReturnNil() async {
        let entity1 = MockEntity()
        let entity2 = MockEntity()
        dataServiceSpy.valuesSubject.send([entity1, entity2])

        let value: MockEntity? = dataManager.entity(with: String(entity2.id.dropFirst()))

        XCTAssertNil(value)
    }

    func test_entity_whenDataServiceIsInvalid_shouldReturnNil() async {
        dataManager = DataManager(dataServices: [])

        let value: MockEntity? = dataManager.entity(with: "")

        XCTAssertNil(value)
    }
}
