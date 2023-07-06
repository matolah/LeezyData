// Created by Mateus Lino

import Foundation
import XCTest

@testable import LeezyData

final class AnyRemoteEntityTests: XCTestCase {
    func test_mockRemoteEntityDecodingFromAnyEntity_whenIdentifierIsValid_shouldDecode() throws {
        let decoder = JSONDecoder()
        let data = Data(
            """
            {
                "identifier": "mock",
                "id": "mock"
            }
            """
                .utf8
        )

        let value = try decoder.decode(AnyRemoteEntity<AnyMockRemoteEntityIdentifier>.self, from: data)

        XCTAssertEqual(value.value as! MockRemoteEntity, MockRemoteEntity(id: "mock"))
        XCTAssertEqual(value.id, "mock")
    }

    func test_mockRemoteEntityDecodingFromAnyEntity_whenIdentifierIsInvalid_shouldFailDecoding() throws {
        let decoder = JSONDecoder()
        let data = Data(
            """
            {
                "identifier": "invalid-mock",
                "id": "mock"
            }
            """
                .utf8
        )

        XCTAssertThrowsError(try decoder.decode(AnyRemoteEntity<AnyMockRemoteEntityIdentifier>.self, from: data))
    }
}
