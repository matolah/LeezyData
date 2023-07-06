// Created by Mateus Lino

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
        case .success(let values):
            XCTAssertEqual(values, [entity])
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    func test_create() async {
        let entity1 = MockEntity(id: "mock")
        dataService.latestValues = [entity1]

        XCTAssertEqual(dataService.latestValues, [entity1])

        let entity2 = MockEntity(id: "mock 2")
        let result = await dataService.create(value: entity2)

        switch result {
        case .success(let value):
            XCTAssertEqual(value, entity2)
            XCTAssertEqual(dataService.latestValues, [entity1, entity2])
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
}
