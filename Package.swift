// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "entity-stores",
    dependencies: [
        .package(
            url: "https://github.com/ordo-one/package-benchmark", .upToNextMajor(from: "1.4.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .testTarget(name: "Tests", dependencies: ["MyNewBenchmarkTarget"]),
        .executableTarget(
            name: "MyNewBenchmarkTarget",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark")
            ],
            path: "Benchmarks/MyNewBenchmarkTarget",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark")
            ]
        )
    ]
)
