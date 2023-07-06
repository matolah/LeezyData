// Created by Mateus Lino

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

    func test_values_whenShouldNotRefetch_shouldReturnLatestLocalValues() async {
        let mockEntity = mockEntity()
        dataServiceSpy.latestValues.append(mockEntity)

        let result: Result<[MockEntity], Error> = await dataManager.values(shouldRefetch: false)

        switch result {
        case .success(let values):
            XCTAssertFalse(dataServiceSpy.fetchAllCalled)
            XCTAssertEqual(values, [mockEntity])
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    private func mockEntity() -> MockEntity {
        return MockEntity(id: UUID().uuidString)
    }

    func test_values_whenShouldRefetch_shouldReturnFetchedValues() async {
        let mockEntity = mockEntity()
        dataServiceSpy.entitiesResultToReturn = .success([mockEntity])

        let result: Result<[MockEntity], Error> = await dataManager.values(shouldRefetch: true)

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

        let result: Result<[MockEntity], Error> = await dataManager.values(shouldRefetch: true)

        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertTrue(error as? DataManagementError == DataManagementError.serviceNotFound)
        }
    }

    func test_create_whenCreatedSuccessfully_shouldReturnCreatedEntity() async {
        let mockEntity = mockEntity()
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

        let result = await dataManager.create(value: mockEntity())

        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertTrue(error as? DataManagementError == DataManagementError.serviceNotFound)
        }
    }

    func test_update_whenUpdatedSuccessfully_shouldReturnUpdatedEntity() async {
        let mockEntity = mockEntity()
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

        let result = await dataManager.update(value: mockEntity())

        switch result {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertTrue(error as? DataManagementError == DataManagementError.serviceNotFound)
        }
    }
}
