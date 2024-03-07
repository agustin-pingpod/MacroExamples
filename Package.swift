// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "MacroExamples",
  platforms: [
    .macOS(.v10_15), .iOS(.v13)
  ],
  products: [
    .library(
        name: "MacroExamples",
        targets: ["MacroExamplesInterface"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
  ],
  targets: [
    .macro(
      name: "MacroExamplesImplementation",
      dependencies: [
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftDiagnostics", package: "swift-syntax"),
      ],
      path: "Sources/MacroExamples/Implementation"
    ),
    .testTarget(
      name: "MacroExamplesImplementationTests",
      dependencies: [
        "MacroExamplesImplementation",
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ],
      path: "Tests/MacroExamples/Implementation"
    ),
    .target(
      name: "MacroExamplesInterface",
      dependencies: [
        "MacroExamplesImplementation"
      ],
      path: "Sources/MacroExamples/Interface"
    ),
    .executableTarget(
      name: "MacroExamplesPlayground",
      dependencies: [
        "MacroExamplesInterface"
      ],
      path: "Sources/MacroExamples/Playground"
    ),
  ]
)
