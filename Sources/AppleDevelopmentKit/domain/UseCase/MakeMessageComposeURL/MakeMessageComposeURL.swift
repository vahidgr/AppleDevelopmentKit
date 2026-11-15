struct MakeMessageComposeURL: Sendable {
    private let service: any MessageComposeServiceProtocol
    private let observabilityService: ObservabilityService
    init(service: any MessageComposeServiceProtocol = MessageComposeService(), observabilityService: ObservabilityService = ObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, recipient: String, body: String?) async -> AppleServiceDomainState {
        var next = state
        do {
            next.messagesComposeURL = try service.makeURL(recipient: recipient, body: body)
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.messagesComposeURL = nil
            next.lastError = String(describing: error)
        }
        return next
    }
}
