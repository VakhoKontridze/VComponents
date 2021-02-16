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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.2.2/VComponents.xcframework.zip",
            checksum: "1e5de58df8ae06880aebcce5e5e6412f69e1b39d9b8d0141727e41be8805b407"
        ),
    ]
)
