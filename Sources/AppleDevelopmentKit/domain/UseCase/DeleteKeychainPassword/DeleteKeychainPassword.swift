struct DeleteKeychainPassword: Sendable {
    private let service: any KeychainPasswordServiceProtocol
    private let observabilityService: ObservabilityService
    init(service: any KeychainPasswordServiceProtocol = KeychainPasswordService(), observabilityService: ObservabilityService = ObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, serviceName: String, account: String) async -> AppleServiceDomainState {
        var next = state
        next.keychainPassword = nil
        do {
            try await service.delete(service: serviceName, account: account)
            next.keychainPassword = nil
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.lastError = String(describing: error)
        }
        return next
    }
}
