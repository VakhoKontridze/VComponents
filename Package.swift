// swift-tools-version: 5.6

import PackageDescription

let package: Package = .init(
    name: "VComponents",
    
    platforms: [
        .iOS(.v15)
    ],
    
    products: [
        .library(
            name: "VComponents",
            targets: ["VComponents"]
        )
    ],
    
    dependencies: [
        //.package(url: "https://github.com/VakhoKontridze/VCore", "3.13.0"..<"4.0.0")
        .package(url: "https://github.com/VakhoKontridze/VCore", branch: "v4.0.0-beta")
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
