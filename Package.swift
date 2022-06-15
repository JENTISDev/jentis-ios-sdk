// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Jentis",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "Jentis",
            targets: ["Jentis"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Jentis",
            dependencies: [],
            resources: [
                .process("Resources/testTrackingData.json"),
            ]
        ),
        .testTarget(
            name: "JentisTests",
            dependencies: ["Jentis"]
        ),
    ]
)
