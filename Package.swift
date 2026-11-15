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
    dependencies: [
        .package(url: "https://github.com/vahidgr/AppleServices.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "AppleDevelopmentKit",
            dependencies: [.product(name: "AppleServices", package: "AppleServices")],
            swiftSettings: [.enableUpcomingFeature("ApproachableConcurrency")]
        ),
        .testTarget(
            name: "AppleDevelopmentKitTests",
            dependencies: ["AppleDevelopmentKit"],
            swiftSettings: [.enableUpcomingFeature("ApproachableConcurrency")]
        ),
    ]
)
