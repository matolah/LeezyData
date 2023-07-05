// Created by Mateus Lino

import Foundation

@testable import LeezyData

final class LocalDataServiceSpy<T: LocalEntity>: DataServiceSpy<T>, LocalDataServiceProtocol {
    private(set) var createEmptyCalled = false
    var entityToReturn: T?

    func createEmpty() -> T? {
        createEmptyCalled = true
        return entityToReturn
    }
}
