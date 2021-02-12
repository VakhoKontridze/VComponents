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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.2.0/VComponents.xcframework.zip",
            checksum: "40217ef1b8a4a026895bbd0b7d8ee955dd8eebcd5399be276809d71192181981"
        ),
    ]
)
