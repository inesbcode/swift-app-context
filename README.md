# AppContext

App bundle metadata and build environment for Apple platforms.

Reading `CFBundleShortVersionString` as a raw string, checking `#if DEBUG` ad-hoc across files, and accessing `Bundle.main` everywhere leads to scattered, untyped boilerplate. `swift-app-context` centralises all of it into three focused types: `AppContext` for bundle metadata, `AppVersion` for typed semantic versioning, and `AppEnvironment` for build configuration.

## Requirements

| Platform | Minimum version |
|----------|----------------|
| iOS      | 16             |
| macOS    | 13             |
| watchOS  | 9              |
| tvOS     | 16             |
| visionOS | 1              |

Swift 6 · Swift Package Manager

## Installation

### Xcode

**File → Add Package Dependencies…**, paste the repository URL, then add `AppContext` to your app target.

### Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/inesbcode/swift-app-context.git", from: "1.0.0"),
],
targets: [
    .target(
        name: "MyApp",
        dependencies: [
            .product(name: "AppContext", package: "swift-app-context"),
        ]
    ),
]
```

## Usage

### Reading bundle metadata

```swift
import AppContext

let context = AppContext()

print(context.version)       // AppVersion — major: 1, minor: 2, patch: 3
print(context.buildNumber)   // "42"
print(context.bundleId)      // "com.mycompany.MyApp"
print(context.displayName)   // "My App"
```

### Checking the build environment

```swift
if context.environment == .debug {
    // enable extra diagnostics
}
```

Or access the environment directly without an `AppContext` instance:

```swift
switch AppEnvironment.current {
case .debug:
    enableVerboseLogging()
case .release:
    break
}
```

### Working with AppVersion

`AppVersion` parses the version string from `Info.plist` into typed integer components:

```swift
let version = context.version  // AppVersion?

version?.major   // 1
version?.minor   // 2
version?.patch   // 3
String(describing: version!)  // "1.2.3"
```

`AppVersion` conforms to `Comparable`, so you can gate behaviour on a minimum version:

```swift
if let version = context.version, version >= AppVersion(major: 2) {
    // enable feature introduced in 2.0
}
```

### Custom bundle

Pass an explicit bundle for framework or test targets:

```swift
let context = AppContext(bundle: Bundle(for: MyClass.self))
```

## API reference

### AppContext

| Property | Type | Source |
|---|---|---|
| `version` | `AppVersion?` | `CFBundleShortVersionString` |
| `buildNumber` | `String?` | `CFBundleVersion` |
| `bundleId` | `String?` | `Bundle.bundleIdentifier` |
| `displayName` | `String?` | `CFBundleDisplayName` / `CFBundleName` |
| `environment` | `AppEnvironment` | `#if DEBUG` compilation condition |

### AppVersion

| Member | Description |
|---|---|
| `init(major:minor:patch:)` | Creates a version from numeric components. `minor` and `patch` default to `0`. |
| `init?(_ string:)` | Parses a dot-separated string such as `"1.2.3"`. Returns `nil` on invalid input. |
| `major`, `minor`, `patch` | `Int` components. |
| `description` | Dot-separated string representation (e.g. `"1.2.3"`). |
| `Comparable` | Ordered by major, then minor, then patch. |

### AppEnvironment

| Member | Description |
|---|---|
| `current` | `static var` — `.debug` when `DEBUG` is defined, `.release` otherwise. |
| `.debug` | The app was built in Debug configuration. |
| `.release` | The app was built in Release configuration. |

## License

MIT — see [LICENSE](LICENSE).
