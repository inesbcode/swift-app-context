/// The build environment in which the app is currently running.
///
/// `AppEnvironment` is derived at compile time from the presence of the `DEBUG`
/// compilation condition. Use ``current`` to read the environment for the active build.
///
/// ```swift
/// switch AppEnvironment.current {
/// case .debug:
///     // enable extra diagnostics
/// case .release:
///     // production path
/// }
/// ```
public enum AppEnvironment {

    /// The app was built with the `DEBUG` compilation condition active (Debug configuration).
    case debug

    /// The app was built without the `DEBUG` compilation condition (Release configuration).
    case release

    // MARK: - Current

    /// The environment for the current build, derived from the `DEBUG` compilation condition.
    ///
    /// Returns `.debug` when `DEBUG` is defined, `.release` otherwise.
    public nonisolated static var current: AppEnvironment {
        #if DEBUG
            .debug
        #else
            .release
        #endif
    }
}

// MARK: - Equatable

extension AppEnvironment: Equatable {
    
    public nonisolated static func == (lhs: AppEnvironment, rhs: AppEnvironment) -> Bool {
        switch (lhs, rhs) {
        case (.debug, .debug), (.release, .release):
            true
        default:
            false
        }
    }
}
