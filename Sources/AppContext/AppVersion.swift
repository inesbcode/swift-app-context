/// A structured representation of a semantic version string (major.minor.patch).
///
/// `AppVersion` parses the dot-separated version string stored in `CFBundleShortVersionString`
/// into typed integer components. Strings with one or two components are accepted;
/// missing components default to `0`.
///
/// ## Parsing
///
/// ```swift
/// AppVersion("2.1.0")  // major: 2, minor: 1, patch: 0
/// AppVersion("1.4")    // major: 1, minor: 4, patch: 0
/// AppVersion("3")      // major: 3, minor: 0, patch: 0
/// AppVersion("bad")    // nil
/// ```
///
/// ## Comparison
///
/// `AppVersion` conforms to `Comparable`, so versions can be compared directly:
///
/// ```swift
/// AppVersion(major: 2) > AppVersion(major: 1, minor: 9, patch: 9)  // true
/// ```
public struct AppVersion {

    /// The major version component.
    public let major: Int

    /// The minor version component.
    public let minor: Int

    /// The patch version component.
    public let patch: Int

    // MARK: - Init

    /// Creates an `AppVersion` from its numeric components.
    ///
    /// - Parameters:
    ///   - major: The major version component.
    ///   - minor: The minor version component. Defaults to `0`.
    ///   - patch: The patch version component. Defaults to `0`.
    public nonisolated init(major: Int, minor: Int = 0, patch: Int = 0) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    /// Creates an `AppVersion` by parsing a version string (e.g. `"1.2.3"`).
    ///
    /// Accepts strings with one, two, or three dot-separated integer components.
    /// Missing components default to `0`. Returns `nil` if any component is not
    /// a valid integer or if the string has more than three parts.
    ///
    /// - Parameter string: A dot-separated version string such as `"1.2.3"`.
    public nonisolated init?(_ string: String) {
        let parts = string.split(separator: ".").map(String.init)
        guard !parts.isEmpty, parts.count <= 3 else { return nil }
        guard let major = Int(parts[0]) else { return nil }
        let minor = parts.count > 1 ? Int(parts[1]) : 0
        let patch = parts.count > 2 ? Int(parts[2]) : 0
        guard let minor, let patch else { return nil }
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}

// MARK: - Equatable

extension AppVersion: Equatable {
    public nonisolated static func == (lhs: AppVersion, rhs: AppVersion) -> Bool {
        lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
    }
}

// MARK: - Comparable

extension AppVersion: Comparable {
    public nonisolated static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
}

// MARK: - CustomStringConvertible

extension AppVersion: CustomStringConvertible {
    /// A dot-separated string representation of the version (e.g. `"1.2.3"`).
    public nonisolated var description: String {
        "\(major).\(minor).\(patch)"
    }
}
