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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.4.3/VComponents.xcframework.zip",
            checksum: "2982e842418fddd6ee43475954c5c67b17479b10d3a29fd3206235305e1e9e07"
        ),
    ]
)
