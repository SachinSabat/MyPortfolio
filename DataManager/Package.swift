// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataManager",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DataManager",
            targets: ["DataManager"]),
    ],
    dependencies: [
        // Specify your package dependencies here.
        .package(name: "NetworkManager", path: "/Users/sacsabat/Desktop/MyPortfolio/NetworkManager"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DataManager",
            dependencies: [
                // Add your dependencies, including the local package.
                "NetworkManager",
            ]),
        .testTarget(
            name: "DataManagerTests",
            dependencies: ["DataManager"]),
    ]
)
