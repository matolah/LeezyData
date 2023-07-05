// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LeezyData",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "LeezyData",
            targets: ["LeezyData"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "10.11.0"))
    ],
    targets: [
        .target(
            name: "LeezyData",
            dependencies: [
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "LeezyDataTests",
            dependencies: ["LeezyData"],
            path: "Tests"
        ),
    ]
)
