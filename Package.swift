// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-rfc-5646",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
    ],
    products: [
        .library(name: "RFC 5646", targets: ["RFC 5646"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-standard-library-extensions.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ascii.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-iso/swift-iso-639.git", branch: "main"),
        .package(url: "https://github.com/swift-iso/swift-iso-3166.git", branch: "main"),
        .package(url: "https://github.com/swift-iso/swift-iso-15924.git", branch: "main"),
        .package(
            url: "https://github.com/swift-molecules/swift-parser.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "RFC 5646",
            dependencies: [
                .product(name: "Standard Library Extensions", package: "swift-standard-library-extensions"),
                .product(name: "ASCII", package: "swift-ascii"),
                .target(name: "ISO 639"),
                .target(name: "ISO 3166"),
                .target(name: "ISO 15924"),
                .product(name: "Parser", package: "swift-parser"),
            ]
        ),
        .testTarget(
            name: "RFC 5646 Tests",
            dependencies: [
                .target(name: "RFC 5646")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
