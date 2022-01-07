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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.6.0/VComponents.xcframework.zip",
            checksum: "62d7991ccae4d9f240c9a143ee2c7f39b0cddb76125ed127a11cac1a7a657cc6"
        ),
    ]
)
