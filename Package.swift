// swift-tools-version: 5.9

import PackageDescription

let package: Package = .init(
    name: "VComponents",
    
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
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
        //.package(url: "https://github.com/VakhoKontridze/VCore", "5.3.1"..<"6.0.0")
        .package(url: "https://github.com/VakhoKontridze/VCore", branch: "feature-6.0.0")
    ],
    
    targets: [
        .target(
            name: "VComponents",
            dependencies: [
                "VCore"
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
