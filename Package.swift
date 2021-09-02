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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.4.2/VComponents.xcframework.zip",
            checksum: "d47431f91352e3c1f0576dd764aca69848b09513efa0e23f1631202d414d7ecf"
        ),
    ]
)
