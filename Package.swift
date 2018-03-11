// swift-tools-version:4.0

//
//  Astral
//  Copyright (c) 2018 Julio Miguel Alorro
//  Licensed under the MIT license. See LICENSE file
//

import PackageDescription

let package = Package(
    name: "BFAstral",
    products: [
        .library(
            name: "BFAstral",
            targets: ["BFAstral"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/hooliooo/Astral", from: "0.9.9"),
        .package(url: "https://github.com/Thomvis/BrightFutures", from: "6.0.0")
    ],
    targets: [
        .target(
            name: "BFAstral",
            dependencies: ["Astral", "BrightFutures"],
            path: "Sources"
        ),
        .testTarget(
            name: "BFAstralTests",
            dependencies: ["BFAstral"],
            path: "Tests"
        )
    ]
)
