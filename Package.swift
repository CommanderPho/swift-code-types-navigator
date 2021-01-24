// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SwiftDiagramGenerator",
    dependencies: [
        .package(
            url: "https://github.com/yanagiba/swift-ast.git",
            from: "0.18.10"),
		.package(url: "https://github.com/CommanderPho/SwiftDiagramComponentsGenerator.git", from: "0.0.1")
    ],
    targets: [
        .target(
            name: "SwiftDiagramGenerator",
            dependencies: ["SwiftDiagramComponentsGenerator"])
    ],
    swiftLanguageVersions: [.v4_2]
)
