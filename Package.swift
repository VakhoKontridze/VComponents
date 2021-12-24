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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.5.0/VComponents.xcframework.zip",
            checksum: "38bcf540b600d8a2446d60e24171335de232c71e2f21358b3fb809cd796d2cdd"
        ),
    ]
)
