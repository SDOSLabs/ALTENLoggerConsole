// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ALTENLoggerConsole",
    platforms: [.iOS(.v14), .macOS(.v11), .tvOS(.v14), .watchOS(.v7)],
    products: [
        .library(
            name: "ALTENLoggerConsole",
            targets: ["ALTENLoggerConsole"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDOSLabs/ALTENLoggerCore.git", .upToNextMajor(from: "1.1.0"))
    ],
    targets: [
        .target(
            name: "ALTENLoggerConsole",
            dependencies: [
                .product(name: "ALTENLoggerCore", package: "ALTENLoggerCore")
            ]),
        .testTarget(
            name: "ALTENLoggerConsoleTests",
            dependencies: [
                "ALTENLoggerConsole"
            ])
    ]
)
