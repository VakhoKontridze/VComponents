// swift-tools-version: 5.10

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .unsafeFlags([
        "-Xfrontend", "-debug-time-function-bodies",
        "-Xfrontend", "-debug-time-expression-type-checking",
        "-Xfrontend", "-warn-long-function-bodies=100",
        "-Xfrontend", "-warn-long-expression-type-checking=100"
    ])
]


let package: Package = .init(
    name: "VComponents",
    
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
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
        //.package(url: "https://github.com/VakhoKontridze/VCore", "6.4.0"..<"7.0.0")
        .package(url: "https://github.com/VakhoKontridze/VCore", branch: "dev")
    ],
    
    targets: [
        .target(
            name: "VComponents",
            dependencies: [
                "VCore"
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: swiftSettings
        )
    ]
)
