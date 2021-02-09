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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.1.0/VComponents.xcframework.zip",
            checksum: "1f9ce7b04d970f1e2a37cb61ba57b88c6db29a7671e23059ec4c86f4a1f3cafd"
        ),
    ]
)
