// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JNFoundation",
    platforms: [
            .iOS(.v12)
        ],
    products: [
        .library(
            name: "JNFoundation",
            targets: ["JNFoundation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Pircate/CleanJSON.git", from: "1.0.9"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.0.0"),
        .package(url: "https://github.com/Tencent/wcdb.git", from: "2.1.10"),
        ],
    targets: [
        .target(
            name: "JNFoundation",
            dependencies: [
                .product(name: "CleanJSON", package: "CleanJSON"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "WCDBSwift", package: "wcdb")
            ],
            path: "Sources",
        )
    ]
)
