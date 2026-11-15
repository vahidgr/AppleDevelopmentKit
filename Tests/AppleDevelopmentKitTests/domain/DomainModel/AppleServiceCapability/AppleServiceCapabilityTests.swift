import Testing
@testable import AppleDevelopmentKit

@Suite struct AppleServiceCapabilityTests {
    @Test func capabilityIsIdentifiedByItsServiceID() {
        let capability = AppleServiceCapability(
            id: "calendar", name: "Calendar", access: .nativeFramework,
            frameworks: ["EventKit"], summary: "Events"
        )
        #expect(capability.id == "calendar")
        #expect(capability.name == "Calendar")
        #expect(capability.access == .nativeFramework)
        #expect(capability.frameworks == ["EventKit"])
        #expect(capability.summary == "Events")
    }
}
