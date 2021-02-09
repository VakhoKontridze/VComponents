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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.0.0/VComponents.xcframework.zip",
            checksum: "d3c7887afee9a6238957bd0414cef1652e901ce908fef24160aa20aa21d1e61a"
        ),
    ]
)
