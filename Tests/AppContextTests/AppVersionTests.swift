import Testing
@testable import AppContext

@Suite("AppVersion")
struct AppVersionTests {

    @Test("parses a full version string")
    func parsesFullVersionString() {
        let version = AppVersion("1.2.3")
        #expect(version?.major == 1)
        #expect(version?.minor == 2)
        #expect(version?.patch == 3)
    }

    @Test("parses a version string with two components")
    func parsesTwoComponentVersionString() {
        let version = AppVersion("2.4")
        #expect(version?.major == 2)
        #expect(version?.minor == 4)
        #expect(version?.patch == 0)
    }

    @Test("parses a version string with one component")
    func parsesOneComponentVersionString() {
        let version = AppVersion("5")
        #expect(version?.major == 5)
        #expect(version?.minor == 0)
        #expect(version?.patch == 0)
    }

    @Test("returns nil for non-integer components")
    func returnsNilForInvalidString() {
        #expect(AppVersion("1.x.3") == nil)
        #expect(AppVersion("bad") == nil)
        #expect(AppVersion("") == nil)
    }

    @Test("returns nil for more than three components")
    func returnsNilForTooManyComponents() {
        #expect(AppVersion("1.2.3.4") == nil)
    }

    @Test("equality holds for identical versions")
    func equality() {
        #expect(AppVersion(major: 1, minor: 2, patch: 3) == AppVersion(major: 1, minor: 2, patch: 3))
        #expect(AppVersion(major: 1) != AppVersion(major: 2))
    }

    @Test("comparison follows semantic versioning precedence")
    func comparison() {
        #expect(AppVersion(major: 2) > AppVersion(major: 1, minor: 9, patch: 9))
        #expect(AppVersion(major: 1, minor: 1) > AppVersion(major: 1, minor: 0, patch: 9))
        #expect(AppVersion(major: 1, minor: 0, patch: 1) > AppVersion(major: 1))
    }

    @Test("description returns dot-separated string")
    func description() {
        #expect(AppVersion(major: 1, minor: 2, patch: 3).description == "1.2.3")
        #expect(AppVersion(major: 3).description == "3.0.0")
    }
}
