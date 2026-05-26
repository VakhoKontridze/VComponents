// swift-tools-version: 6.3

import PackageDescription

let package: Package = .init(
    name: "VComponents",
    
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    
    products: [
        .library(
            name: "VComponents",
            targets: [
                "VComponents"
            ]
        )
    ],
    
    dependencies: [
        //.package(url: "https://github.com/VakhoKontridze/VCore", "8.0.1"..<"9.0.0")
        .package(url: "https://github.com/VakhoKontridze/VCore", branch: "dev")
    ],
    
    targets: [
        .target(
            name: "VComponents",
            dependencies: [
                "VCore"
            ],
            exclude: [
                "../../Documentation"
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self),
                .enableUpcomingFeature("ApproachableConcurrency"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("MemberImportVisibility")
            ]
        )
    ]
)
