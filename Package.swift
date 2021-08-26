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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.4.0/VComponents.xcframework.zip",
            checksum: "14aeae4adc981afaed92c147bd00f69d7f10937a55ed3fd55e4110e660630182"
        ),
    ]
)
