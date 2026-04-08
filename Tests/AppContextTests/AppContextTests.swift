import Foundation
import Testing
@testable import AppContext

@Suite("AppContext")
struct AppContextTests {

    let context = AppContext()

    @Test("all bundle info properties are accessible without crashing")
    func bundleInfoProperties() {
        _ = context.version
        _ = context.buildNumber
        _ = context.bundleId
        _ = context.displayName
    }

    @Test("environment property is accessible without crashing")
    func environmentProperty() {
        _ = context.environment
    }

    @Test("environment is either debug or release")
    func environmentIsValid() {
        let env = context.environment
        #expect(env == .debug || env == .release)
    }

    @Test("custom bundle can be injected at init")
    func customBundleInjection() {
        let custom = AppContext(bundle: .main)
        _ = custom.version
        _ = custom.bundleId
    }

    @Test("properties are safe to read from concurrent tasks")
    func concurrencySafe() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { _ = self.context.version }
            group.addTask { _ = self.context.buildNumber }
            group.addTask { _ = self.context.bundleId }
            group.addTask { _ = self.context.displayName }
            group.addTask { _ = self.context.environment }
        }
    }
}
