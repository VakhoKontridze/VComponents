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
        .package(url: "https://github.com/VakhoKontridze/VCore", "3.2.0"..<"4.0.0")
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
