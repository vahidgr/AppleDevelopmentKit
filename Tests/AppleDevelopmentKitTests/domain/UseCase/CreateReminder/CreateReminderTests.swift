import Testing
@testable import AppleDevelopmentKit

@Suite struct CreateReminderTests {
    @Test func storesCreatedReminderIdentifier() async {
        let state = await CreateReminder(service: MockReminderService(result: .success("reminder-1")))
            .execute(AppleServiceDomainState(), title: "Task", dueDate: nil)
        #expect(state.reminderIdentifier == "reminder-1")
        #expect(state.lastError == nil)
    }
    @Test func logsAndStoresFailure() async {
        let state = await CreateReminder(service: MockReminderService(result: .failure(.failed)))
            .execute(AppleServiceDomainState(), title: "Task", dueDate: nil)
        #expect(state.reminderIdentifier == nil)
        #expect(state.lastError != nil)
    }
}
