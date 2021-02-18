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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.3.0/VComponents.xcframework.zip",
            checksum: "274c8ea1ae256d87c1d76d131ddc8efc0d71245efa1c7268caca00f06f36e9a4"
        ),
    ]
)
