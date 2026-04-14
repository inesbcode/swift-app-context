import Testing
@testable import AppContext

@Suite("AppRuntime")
struct AppRuntimeTests {

    @Test("current is accessible without crashing")
    func currentIsAccessible() {
        _ = AppRuntime.current
    }

    @Test("current is either simulator or device")
    func currentIsValid() {
        let runtime = AppRuntime.current
        #expect(runtime == .simulator || runtime == .device)
    }

    @Test("equality works correctly")
    func equality() {
        #expect(AppRuntime.simulator == .simulator)
        #expect(AppRuntime.device == .device)
        #expect(AppRuntime.simulator != .device)
    }
}
