// Created by Mateus Lino

import Foundation

extension Encodable {
    public var dictionary: [String: Any] {
        guard let jsonData = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }

    public var trimmedNilDictionary: [String: Any] {
        return dictionary.compactMapValues { $0 }
    }
}
