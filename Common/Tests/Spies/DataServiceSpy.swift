// Created by Mateus Lino

import Combine
import Foundation

@testable import LeezyData

class DataServiceSpy<T: Entity>: DataServiceProtocol {
    var valuesSubject = CurrentValueSubject<[T], Error>([])
    
    private(set) var fetchAllCalled = false
    var entitiesResultToReturn: Result<[T], Error>!
    private(set) var createCalled = false
    var entityResultToReturn: Result<T, Error>!
    private(set) var updateCalled = false

    func fetchAll() async -> Result<[T], Error> {
        fetchAllCalled = true
        return entitiesResultToReturn
    }

    func create(value: T) async -> Result<T, Error> {
        createCalled = true
        return entityResultToReturn
    }

    func update(value: T) async -> Result<T, Error> {
        updateCalled = true
        return entityResultToReturn
    }
}
