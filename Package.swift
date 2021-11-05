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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.4.5/VComponents.xcframework.zip",
            checksum: "d2739bdda5a6750f5888b94db98430bad079eb9ecda0f8d4720bae88b5388cc0"
        ),
    ]
)
