// Created by Mateus Lino

import Foundation

public extension Encodable {
    var dictionary: [String: Any] {
        guard let jsonData = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
        else {
            return [:]
        }
        return dictionary
    }

    var trimmedNilDictionary: [String: Any] {
        dictionary.compactMapValues { $0 }
    }
}
