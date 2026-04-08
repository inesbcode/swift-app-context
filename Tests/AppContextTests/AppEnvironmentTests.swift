import Testing
@testable import AppContext

@Suite("AppEnvironment")
struct AppEnvironmentTests {

    @Test("current is accessible without crashing")
    func currentIsAccessible() {
        _ = AppEnvironment.current
    }

    @Test("current is either debug or release")
    func currentIsValid() {
        let env = AppEnvironment.current
        #expect(env == .debug || env == .release)
    }

    @Test("equality works correctly")
    func equality() {
        #expect(AppEnvironment.debug == .debug)
        #expect(AppEnvironment.release == .release)
        #expect(AppEnvironment.debug != .release)
    }
}
