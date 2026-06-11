// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "FlowDesign",
    platforms: [
        .macOS(.v26)
    ],
    products: [
        .executable(name: "FlowDesignApp", targets: ["FlowDesignApp"]),
        .library(name: "FlowDesignCore", targets: ["FlowDesignCore"]),
        .library(name: "FlowDesignPaperKit", targets: ["FlowDesignPaperKit"])
    ],
    targets: [
        .executableTarget(
            name: "FlowDesignApp",
            dependencies: [
                "FlowDesignCore",
                "FlowDesignPaperKit"
            ]
        ),
        .target(
            name: "FlowDesignCore"
        ),
        .target(
            name: "FlowDesignPaperKit",
            dependencies: [
                "FlowDesignCore"
            ]
        ),
        .testTarget(
            name: "FlowDesignCoreTests",
            dependencies: [
                "FlowDesignCore"
            ]
        )
    ]
)
