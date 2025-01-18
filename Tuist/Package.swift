// swift-tools-version: 5.9
@preconcurrency import PackageDescription

#if TUIST
@preconcurrency import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "RxSwift" : .framework,
        "Then" : .framework,
        "SnapKit" : .framework,
        "RxCocoa" : .framework,
        "RxCocoaRuntime" : .framework,
        "RxRelay" : .framework
    ])
#endif

let package = Package(
    name: "githubClone",
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.8.0"),
        .package(url: "https://github.com/devxoul/Then", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.7.1")
    ]
)
