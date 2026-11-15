struct MakeMessageComposeURL: Sendable {
    private let service: any MessageComposeServiceProtocol
    private let observabilityService: any ObservabilityServiceProtocol
    init(service: any MessageComposeServiceProtocol, observabilityService: any ObservabilityServiceProtocol = NullObservabilityService()) {
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
