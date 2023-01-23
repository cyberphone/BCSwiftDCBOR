// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "CBOR",
    products: [
        .library(
            name: "CBOR",
            targets: ["CBOR"]),
    ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/swift-collections", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/wolfmcnally/WolfBase.git", .upToNextMajor(from: "5.0.0")),
    ],
    targets: [
        .target(
            name: "CBOR",
            dependencies: [
                "WolfBase",
                .product(name: "Collections", package: "swift-collections"),
            ]),
        .testTarget(
            name: "CBORTests",
            dependencies: ["CBOR"]),
    ]
)
