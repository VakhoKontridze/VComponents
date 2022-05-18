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
    
    targets: [
        .target(
            name: "VComponents",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
