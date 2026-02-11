// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyLibrary",
    products: [
        .library(
            name: "MyLibrary",
            targets: ["MyLibrary"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "14.0.0")),
        .package(url: "https://github.com/jdg/MBProgressHUD.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/mac-cain13/R.swift", from: "5.1.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager.git", from: "6.5.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git",.upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "3.2.1"),
    ],
    targets: [
        .target(
            name: "MyLibrary",
            dependencies: ["Moya",
                           "MBProgressHUD",
                           "SnapKit",
                           "Kingfisher",
                           .product(name: "Lottie", package: "lottie-ios"),
                           .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager")
                           ],
            resources: []),
        .testTarget(
            name: "MyLibraryTests",
            dependencies: ["MyLibrary"]
        ),
    ]
)
