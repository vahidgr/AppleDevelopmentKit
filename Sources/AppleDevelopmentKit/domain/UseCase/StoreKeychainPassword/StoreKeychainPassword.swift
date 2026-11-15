import Foundation

struct StoreKeychainPassword: Sendable {
    private let service: any KeychainPasswordServiceProtocol
    private let observabilityService: any ObservabilityServiceProtocol
    init(service: any KeychainPasswordServiceProtocol, observabilityService: any ObservabilityServiceProtocol = NullObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, serviceName: String, account: String, password: Data) async -> AppleServiceDomainState {
        var next = state
        next.keychainPassword = nil
        do {
            try await service.store(service: serviceName, account: account, password: password)
            next.keychainPassword = nil
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.lastError = String(describing: error)
        }
        return next
    }
}
