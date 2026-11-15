import Foundation

struct CreateCalendarEvent: Sendable {
    private let service: any CalendarEventServiceProtocol
    private let observabilityService: any ObservabilityServiceProtocol
    init(service: any CalendarEventServiceProtocol, observabilityService: any ObservabilityServiceProtocol = NullObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, title: String, startDate: Date, endDate: Date) async -> AppleServiceDomainState {
        var next = state
        do {
            next.calendarEventIdentifier = try await service.create(title: title, startDate: startDate, endDate: endDate)
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.calendarEventIdentifier = nil
            next.lastError = String(describing: error)
        }
        return next
    }
}
