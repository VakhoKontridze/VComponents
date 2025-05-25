// swift-tools-version: 6.1

import PackageDescription

let package: Package = .init(
    name: "VComponents",
    
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
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
        .package(url: "https://github.com/VakhoKontridze/VCore", "7.5.2"..<"8.0.0")
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
            ]
        )
    ]
)
