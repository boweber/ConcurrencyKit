// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConcurrencyKit",
    platforms: [.macOS("12.0"), .iOS("15.0")],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ConcurrencyKit",
            targets: ["ConcurrencyKit"]),
        .library(
            name: "ConcurrencyTesting",
            targets: ["ConcurrencyTesting"]
        )
    ],
    dependencies: [],
    targets: [
        .target(name: "ConcurrencyTesting"),
        .target(name: "ConcurrencyKit"),
        .testTarget(
            name: "ConcurrencyKitTests",
            dependencies: ["ConcurrencyKit", "ConcurrencyTesting"]),
    ]
)
