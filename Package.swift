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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.4.6/VComponents.xcframework.zip",
            checksum: "268e237d2fee376db450c94f3d21a72f7e7780bafeaae28cecd280d5802efc55"
        ),
    ]
)
