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
            url: "https://github.com/VakhoKontridze/VComponents/releases/download/1.3.1/VComponents.xcframework.zip",
            checksum: "bef472867e560b4513c540449b40caec7ce8569ffee5bdab5bc12ec9205988c1"
        ),
    ]
)
