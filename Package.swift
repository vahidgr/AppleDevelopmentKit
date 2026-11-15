// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "AppleDevelopmentKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "AppleDevelopmentKit", targets: ["AppleDevelopmentKit"]),
    ],
    targets: [
        .target(
            name: "AppleDevelopmentKit",
            swiftSettings: [.enableUpcomingFeature("ApproachableConcurrency")]
        ),
        .testTarget(
            name: "AppleDevelopmentKitTests",
            dependencies: ["AppleDevelopmentKit"],
            swiftSettings: [.enableUpcomingFeature("ApproachableConcurrency")]
        ),
    ]
)
