// Created by Mateus Lino

import CoreData
import Foundation
import XCTest

@testable import LeezyCoreData

final class CoreDataServiceTests: XCTestCase {
    private final class CoreDataStack: NSObject {
        lazy var container: NSPersistentContainer = {
            guard let mom = NSManagedObjectModel.mergedModel(from: [Bundle.module]) else {
                fatalError("Failed to create mom")
            }
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            let container = NSPersistentContainer(name: "Model", managedObjectModel: mom)
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { _, error in
                if let error {
                    fatalError("Failed to load persistent store \(error)")
                }
                print("Loaded")
            }
            return container
        }()
    }

    private var dataService: CoreDataDataService<MockCoreDataEntity>!
    private var coreDataStack: CoreDataStack!
    private var dataManager: DataManager!
    private var referenceDataService: DataService<MockReferenceEntity>!

    override func setUp() {
        super.setUp()

        coreDataStack = CoreDataStack()
        dataService = CoreDataDataService(managedObjectContext: coreDataStack.container.viewContext)
        referenceDataService = DataService()
        dataManager = DataManager(dataServices: [dataService, referenceDataService])

        MockCoreDataEntity.referenceBuilder = dataManager
        MockCoreDataEntity.coreDataEntityBuilder = dataManager
    }

    override func tearDown() {
        coreDataStack = nil
        dataService = nil

        super.tearDown()
    }

    func test_fetchAll_whenFetchIsSuccessful_shouldReturnEntities() async {
        guard let values = createEntityAndReference() else {
            XCTFail()
            return
        }
        let entity = values.0
        let reference = values.1

        XCTAssertEqual(entity.reference, reference)
        XCTAssertEqual(dataService.latestValues, [])

        let result = await dataService.fetchAll()

        switch result {
        case let .success(values):
            XCTAssertEqual(values, [entity])
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }

    private func createEntityAndReference() -> (MockCoreDataEntity, MockReferenceEntity)? {
        let reference = MockReferenceEntity()
        guard let entity = MockCoreDataEntity.create() else {
            return nil
        }
        referenceDataService.latestValues.append(reference)
        entity.referenceID = reference.id
        return (entity, reference)
    }

    func test_create_whenCreationIsSuccessful_shouldReturnCreatedEntity() async {
        guard let values = createEntityAndReference() else {
            XCTFail()
            return
        }
        let entity = values.0
        let reference = values.1

        XCTAssertEqual(entity.reference, reference)
        XCTAssertEqual(dataService.latestValues, [])

        let result = await dataService.create(value: entity)

        switch result {
        case let .success(value):
            XCTAssertEqual(value, entity)
            XCTAssertEqual(dataService.latestValues, [entity])
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }

    func test_update_whenUpdateIsSuccessful_shouldReturnUpdatedEntity() async {
        guard let values = createEntityAndReference() else {
            XCTFail()
            return
        }
        let entity = values.0
        let reference = values.1

        XCTAssertEqual(entity.reference, reference)

        dataService.latestValues.append(entity)
        entity.title = "mock title"

        let result = await dataService.update(value: entity)

        switch result {
        case let .success(value):
            XCTAssertEqual(value, entity)
            XCTAssertEqual(dataService.latestValues, [entity])
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }
}
