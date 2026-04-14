/// The runtime environment in which the app is currently executing.
///
/// `AppRuntime` is derived at compile time from the `targetEnvironment` condition.
/// Use ``current`` to read the runtime for the active build target.
///
/// ```swift
/// switch AppRuntime.current {
/// case .simulator:
///     // running inside the iOS/watchOS/tvOS Simulator
/// case .device:
///     // running on a physical device
/// }
/// ```
public enum AppRuntime {

    /// The app is running inside a simulator (e.g. iOS Simulator, watchOS Simulator).
    case simulator

    /// The app is running on a physical device.
    case device

    // MARK: - Current

    /// The runtime environment for the current build, derived from the `targetEnvironment` condition.
    ///
    /// Returns `.simulator` when `targetEnvironment(simulator)` is active, `.device` otherwise.
    public nonisolated static var current: AppRuntime {
        #if targetEnvironment(simulator)
            .simulator
        #else
            .device
        #endif
    }
}

// MARK: - Equatable

extension AppRuntime: Equatable {

    public nonisolated static func == (lhs: AppRuntime, rhs: AppRuntime) -> Bool {
        switch (lhs, rhs) {
        case (.simulator, .simulator), (.device, .device):
            true
        default:
            false
        }
    }
}
