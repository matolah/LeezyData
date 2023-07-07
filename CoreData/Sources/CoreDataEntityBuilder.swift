// Created by Mateus Lino

import Foundation
import LeezyData

public protocol CoreDataEntityBuilderProtocol {
    func create<T: CoreDataEntity>() -> T?
}

extension DataManager: CoreDataEntityBuilderProtocol {
    public func create<T: CoreDataEntity>() -> T? {
        guard let dataService = dataService(T.self) as? any CoreDataDataServiceProtocol<T>,
              let newValue = dataService.createEmpty() else {
            return nil
        }
        newValue.id = UUID().uuidString
        return newValue as? T
    }
}
