// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "AppleServiceUseCases",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "AppleServiceUseCases", targets: ["AppleServiceUseCases"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vahidgr/AppleServices.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "AppleServiceUseCases",
            dependencies: [.product(name: "AppleServices", package: "AppleServices")],
            swiftSettings: [.enableUpcomingFeature("ApproachableConcurrency")]
        ),
        .testTarget(
            name: "AppleServiceUseCasesTests",
            dependencies: ["AppleServiceUseCases"],
            swiftSettings: [.enableUpcomingFeature("ApproachableConcurrency")]
        ),
    ]
)
