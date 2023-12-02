// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DCBOR",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
        .macCatalyst(.v14)
    ],
    products: [
        .library(
            name: "DCBOR",
            targets: ["DCBOR"]),
    ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/swift-collections", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/wolfmcnally/WolfBase.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/blockchaincommons/BCSwiftFloat16.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "DCBOR",
            dependencies: [
                .product(name: "BCFloat16", package: "BCSwiftFloat16"),
                .product(name: "Collections", package: "swift-collections"),
            ]),
        .testTarget(
            name: "DCBORTests",
            dependencies: [
                "DCBOR",
                "WolfBase",
            ]),
    ]
)
