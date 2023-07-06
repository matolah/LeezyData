// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LeezyData",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "LeezyData",
            targets: [
                "LeezyData"
            ]
        ),
        .library(
            name: "LeezyCoreData",
            targets: [
                "LeezyCoreData"
            ]
        ),
        .library(
            name: "LeezyRemoteCollection",
            targets: [
                "LeezyRemoteCollection"
            ]
        ),
        .library(
            name: "LeezyFirestore",
            targets: [
                "LeezyFirestore"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "10.11.0"))
    ],
    targets: [
        .target(
            name: "LeezyData",
            path: "Core/Sources"
        ),
        .testTarget(
            name: "LeezyDataTests",
            dependencies: ["LeezyData"],
            path: "Core/Tests"
        ),

        .target(
            name: "LeezyCoreData",
            dependencies: [
              "LeezyData"
            ],
            path: "CoreData/Sources"
        ),

        .target(
            name: "LeezyRemoteCollection",
            dependencies: [
              "LeezyData"
            ],
            path: "RemoteCollection/Sources"
        ),
        .testTarget(
            name: "LeezyRemoteCollectionTests",
            dependencies: ["LeezyRemoteCollection"],
            path: "RemoteCollection/Tests"
        ),

        .target(
            name: "LeezyFirestore",
            dependencies: [
                "LeezyRemoteCollection",
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk")
            ],
            path: "Firestore/Sources"
        ),
    ]
)
