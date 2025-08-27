// swift-tools-version: 6.1
// FIXME: Replace with 6.2
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
        //.package(url: "https://github.com/VakhoKontridze/VCore", "8.0.0"..<"9.0.0")
        .package(url: "https://github.com/VakhoKontridze/VCore", branch: "feature-8.0.0")
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
