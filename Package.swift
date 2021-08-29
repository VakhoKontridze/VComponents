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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.4.1/VComponents.xcframework.zip",
            checksum: "7cf5738ea4161ae935fbfdcfc62ed884706f3b91fd46a2408ef027640e45079d"
        ),
    ]
)
