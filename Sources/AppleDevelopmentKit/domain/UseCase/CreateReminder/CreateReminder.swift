import Foundation

struct CreateReminder: Sendable {
    private let service: any ReminderServiceProtocol
    private let observabilityService: ObservabilityService
    init(service: any ReminderServiceProtocol = ReminderService(), observabilityService: ObservabilityService = ObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, title: String, dueDate: Date?) async -> AppleServiceDomainState {
        var next = state
        do {
            next.reminderIdentifier = try await service.create(title: title, dueDate: dueDate)
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.reminderIdentifier = nil
            next.lastError = String(describing: error)
        }
        return next
    }
}
