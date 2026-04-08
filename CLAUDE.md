# swift-app-context

Lightweight app context reader for Apple platforms. Provides a `struct AppContext` that reads
metadata from a `Bundle` and exposes build-time environment information (debug vs. release)
via compiler flags.

## Project structure

```
Sources/   – production code (AppContext target)
Tests/     – unit tests (AppContextTests target)
```

## Test conventions

Each test file contains exactly one `@Suite` and the suite name must match the
production type under test (e.g. `AppContext` → `AppContextTests`,
`AppVersion` → `AppVersionTests`, `AppEnvironment` → `AppEnvironmentTests`).

Test files live flat inside `Tests/AppContextTests/` and mirror the source files
in `Sources/AppContext/`:

```
Sources/AppContext/AppContext.swift       → Tests/AppContextTests/AppContextTests.swift
Sources/AppContext/AppVersion.swift      → Tests/AppContextTests/AppVersionTests.swift
Sources/AppContext/AppEnvironment.swift  → Tests/AppContextTests/AppEnvironmentTests.swift
```

Never put multiple suites in one file, and never group tests for different types
into the same suite even if they exercise related concerns — merge those into the
single suite for that type instead.

## How it works

`AppContext` is a `struct` initialised with a `Bundle` (defaults to `Bundle.main`). Each
computed property reads a specific `Info.plist` key or evaluates a compile-time `#if DEBUG`
condition. All members are `nonisolated` so they are callable from any isolation context
without `await`.

Typical usage — create one instance per app target and pass or store it where needed:

```swift
let context = AppContext()
print(context.version)      // "1.2.3"
print(context.buildNumber)  // "42"
print(context.environment)  // .debug or .release
```

## Swift 6 notes

- `swiftSettings` includes `.defaultIsolation(MainActor.self)`, so every declaration in the
  target is implicitly `@MainActor` unless marked otherwise.
- All `AppContext` properties are `nonisolated` — they can be read from any isolation context
  without `await`.
- The `init` is also `nonisolated` so `AppContext` can be created from any isolation context.

## Documentation

All public declarations must have a doc comment (`///`).
The top-level `struct AppContext` doc comment must include:
- One-line summary
- Setup / instantiation example
- Basic usage example
- Environment-checking example

Individual properties require only a one-line summary describing the value they expose,
plus a note about the `Info.plist` key or compilation condition used.

## Adding a property

**Bundle-derived property** — read a key from `bundle.infoDictionary`:

```swift
/// One-line description of the value.
///
/// Read from the `<PlistKey>` key in the bundle's `Info.plist`.
/// Returns `nil` when the key is absent.
public nonisolated var myProperty: String? {
    bundle.infoDictionary?["<PlistKey>"] as? String
}
```

**Environment-derived property** — use a `#if` compilation condition:

```swift
/// One-line description of the value.
public nonisolated var myFlag: Bool {
    #if SOME_FLAG
        true
    #else
        false
    #endif
}
```

The body of every `#if`/`#else`/`#endif` branch must be indented one level relative to the
directive itself. `swift-format.json` sets `indentConditionalCompilationBlocks: false`, which
prevents the formatter from touching this indentation — so it must be maintained by hand.

Then add `_ = context.myProperty` (or `_ = context.myFlag`) to the corresponding
`@Test` function in `AppContextTests.swift`.

## Key decisions (do not reverse without discussion)

- **One file per type.** Each public type lives in its own file under `Sources/AppContext/`.
- **`struct` with init.** `AppContext` is initialised with a bundle. Do not convert it to an
  enum or make members static.
- **Computed `var`, not `let`.** Properties are computed so the bundle stored at init time is
  always used. Do not convert to stored `let` properties.
- **No dependencies.** The package must remain dependency-free.
- **`Optional` for bundle keys.** Bundle-derived properties return `String?` because
  `Info.plist` keys may be absent in test runners or framework targets.

## Commands

```bash
swift build
swift test

# Format (uses Xcode-bundled swift-format via active toolchain)
xcrun swift-format format --in-place --recursive --configuration swift-format.json Sources/ Tests/
```
