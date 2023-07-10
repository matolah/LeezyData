// swift-tools-version: 5.7
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
                "LeezyData",
                "LeezyCoreData"
            ]
        ),
        .library(
            name: "LeezyRemoteCollection",
            targets: [
                "LeezyData",
                "LeezyRemoteCollection"
            ]
        ),
        .library(
            name: "LeezyFirestore",
            targets: [
                "LeezyData",
                "LeezyRemoteCollection",
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
            path: "Common/Sources"
        ),
        .testTarget(
            name: "LeezyDataTests",
            dependencies: ["LeezyData"],
            path: "Common/Tests"
        ),
        .target(
            name: "LeezyCoreData",
            dependencies: [
              "LeezyData"
            ],
            path: "CoreData/Sources"
        ),
        .testTarget(
            name: "LeezyCoreDataTests",
            dependencies: ["LeezyCoreData"],
            path: "CoreData/Tests"
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
