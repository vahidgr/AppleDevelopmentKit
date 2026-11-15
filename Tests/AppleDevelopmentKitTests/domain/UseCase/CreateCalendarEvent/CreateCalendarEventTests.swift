import Testing
@testable import AppleDevelopmentKit

@Suite struct CreateCalendarEventTests {
    @Test func storesCreatedEventIdentifier() async {
        let state = await CreateCalendarEvent(service: MockCalendarEventService(result: .success("event-1")))
            .execute(AppleServiceDomainState(), title: "Meeting", startDate: .now, endDate: .now.addingTimeInterval(60))
        #expect(state.calendarEventIdentifier == "event-1")
        #expect(state.lastError == nil)
    }
    @Test func logsAndStoresFailure() async {
        let state = await CreateCalendarEvent(service: MockCalendarEventService(result: .failure(.failed)))
            .execute(AppleServiceDomainState(), title: "Meeting", startDate: .now, endDate: .now.addingTimeInterval(60))
        #expect(state.calendarEventIdentifier == nil)
        #expect(state.lastError != nil)
    }
}
