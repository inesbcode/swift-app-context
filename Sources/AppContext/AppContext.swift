import Foundation

/// A namespace of read-only properties describing the current app bundle and execution environment.
///
/// `AppContext` provides a single, zero-configuration entry point for accessing app metadata
/// and build-time environment information. All values are derived from `Bundle` and compiler
/// flags at init time and remain constant for the lifetime of the instance.
///
/// ## Setup
///
/// `AppContext` is initialised with a `Bundle` parameter that defaults to `Bundle.main`, so
/// no explicit setup is needed for app targets:
///
/// ```swift
/// let context = AppContext()
/// ```
///
/// For framework or package test targets, pass the relevant bundle explicitly:
///
/// ```swift
/// let context = AppContext(bundle: Bundle(for: MyClass.self))
/// ```
///
/// ## Basic usage
///
/// ```swift
/// let context = AppContext()
///
/// print(context.version)       // e.g. AppVersion(major: 1, minor: 2, patch: 3)
/// print(context.buildNumber)   // e.g. "42"
/// print(context.bundleId)      // e.g. "com.mycompany.MyApp"
/// print(context.displayName)   // e.g. "My App"
/// print(context.environment)   // .debug or .release
/// ```
///
/// ## Checking the environment
///
/// ```swift
/// if context.environment == .debug {
///     // enable extra diagnostics
/// }
/// ```
///
/// - Note: All members are `nonisolated` so they can be read from any isolation context
///   without `await`, regardless of the module's default `@MainActor` isolation.
public struct AppContext {

    private let bundle: Bundle

    // MARK: - Init

    /// Creates an `AppContext` backed by the given bundle.
    ///
    /// - Parameter bundle: The bundle from which metadata is read. Defaults to `Bundle.main`.
    public nonisolated init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    // MARK: - Bundle info

    /// The marketing version of the app parsed into major, minor, and patch components.
    ///
    /// Read from the `CFBundleShortVersionString` key in the bundle's `Info.plist` and
    /// parsed by ``AppVersion/init(_:)``. Returns `nil` when the key is absent or
    /// the value cannot be parsed (e.g. in plain Swift package test runners).
    public nonisolated var version: AppVersion? {
        guard let string = bundle.infoDictionary?["CFBundleShortVersionString"] as? String else { return nil }
        return AppVersion(string)
    }

    /// The build number string of the app (e.g. `"42"`).
    ///
    /// Read from the `CFBundleVersion` key in the bundle's `Info.plist`.
    /// Returns `nil` when the key is absent.
    public nonisolated var buildNumber: String? {
        bundle.infoDictionary?["CFBundleVersion"] as? String
    }

    /// The reverse-DNS bundle identifier of the app (e.g. `"com.mycompany.MyApp"`).
    ///
    /// Returns `nil` when the bundle has no identifier (e.g. plain Swift package test runners).
    public nonisolated var bundleId: String? {
        bundle.bundleIdentifier
    }

    /// The user-visible display name of the app (e.g. `"My App"`).
    ///
    /// Read from `CFBundleDisplayName` first, then `CFBundleName` as a fallback.
    /// Returns `nil` when neither key is present.
    public nonisolated var displayName: String? {
        (bundle.infoDictionary?["CFBundleDisplayName"] as? String) ??
        (bundle.infoDictionary?["CFBundleName"] as? String)
    }

    // MARK: - Environment

    /// The build environment derived from the presence of the `DEBUG` compilation condition.
    ///
    /// Delegates to ``AppEnvironment/current``. Returns `.debug` in Debug builds,
    /// `.release` in Release builds.
    public nonisolated var environment: AppEnvironment {
        .current
    }

    /// The runtime environment derived from the `targetEnvironment` compilation condition.
    ///
    /// Delegates to ``AppRuntime/current``. Returns `.simulator` when running inside a
    /// simulator, `.device` when running on a physical device.
    public nonisolated var runtime: AppRuntime {
        .current
    }
}
