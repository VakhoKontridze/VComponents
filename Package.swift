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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.2.1/VComponents.xcframework.zip",
            checksum: "7e6ecd8a7ee84ffe6db04c0d69f5ee55175a913790f9c36b8ebd14f22ef941c4"
        ),
    ]
)
