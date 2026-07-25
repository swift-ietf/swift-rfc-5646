# swift-rfc-5646

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The language-tag syntax of RFC 5646, the normative body of BCP 47.

## Standard Reference

- **RFC**: 5646
- **Title**: Tags for Identifying Languages

## Installation

Add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/swift-ietf/swift-rfc-5646.git", from: "0.2.4")
]
```

Add the product to a target that needs it:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RFC 5646", package: "swift-rfc-5646")
    ]
)
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
