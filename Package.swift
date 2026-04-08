// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "swift-app-context",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "AppContext",
            targets: ["AppContext"]
        ),
    ],
    targets: [
        .target(
            name: "AppContext",
            swiftSettings: [
                .defaultIsolation(MainActor.self),
            ]
        ),
        .testTarget(
            name: "AppContextTests",
            dependencies: ["AppContext"],
            swiftSettings: [
                .defaultIsolation(MainActor.self),
            ]
        ),
    ],
    swiftLanguageModes: [
        .v6,
        .v5,
    ]
)
