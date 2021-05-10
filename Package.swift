// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "IPC",
    products: [
        .library(
            name: "IPC",
            targets: ["IPC"]),
    ],
    dependencies: [
        .package(name: "Test")
    ],
    targets: [
        .target(
            name: "IPC",
            dependencies: [],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"]),
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"])
            ]),
    ]
)

// MARK: - tests

testTarget("IPC") { test in
    test("Broadcast")
    test("Condition")
}

func testTarget(_ target: String, task: ((String) -> Void) -> Void) {
    task { test in addTest(target: target, name: test) }
}

func addTest(target: String, name: String) {
    package.targets.append(
        .executableTarget(
            name: "Tests/\(target)/\(name)",
            dependencies: ["IPC", "Test"],
            path: "Tests/\(target)/\(name)",
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"]),
                .unsafeFlags(["-Xfrontend", "-enable-experimental-concurrency"])
            ]))
}

// MARK: - custom package source

#if canImport(ObjectiveC)
import Darwin.C
#else
import Glibc
#endif

extension Package.Dependency {
    enum Source: String {
        case local, remote, github

        static var `default`: Self { .local }

        var baseUrl: String {
            switch self {
            case .local: return "../"
            case .remote: return "https://swiftstack.io/"
            case .github: return "https://github.com/swift-stack/"
            }
        }

        func url(for name: String) -> String {
            return self == .local
                ? baseUrl + name.lowercased()
                : baseUrl + name.lowercased() + ".git"
        }
    }

    static func package(name: String) -> Package.Dependency {
        guard let pointer = getenv("SWIFTSTACK") else {
            return .package(name: name, source: .default)
        }
        guard let source = Source(rawValue: String(cString: pointer)) else {
            fatalError("Invalid source. Use local, remote or github")
        }
        return .package(name: name, source: source)
    }

    static func package(name: String, source: Source) -> Package.Dependency {
        return source == .local
            ? .package(name: name, path: source.url(for: name))
            : .package(name: name, url: source.url(for: name), .branch("dev"))
    }
}
