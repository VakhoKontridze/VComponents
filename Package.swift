// swift-tools-version:5.3

import PackageDescription

let package: Package = .init(
    name: "VComponents",
    
    platforms: [
        .iOS(.v14)
    ],
    
    products: [
        .library(
            name: "VComponents",
            targets: ["VComponents"]
        )
    ],
    
    targets: [
        .binaryTarget(
            name: "VComponents",
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.1.1/VComponents.xcframework.zip",
            checksum: "77b38089814a86f78f72ad211bd1b622adf5834585f9e6aac6d617cb5b363e50"
        ),
    ]
)
