import Foundation

struct ReadKeychainPassword: Sendable {
    private let service: any KeychainPasswordServiceProtocol
    private let observabilityService: any ObservabilityServiceProtocol
    init(service: any KeychainPasswordServiceProtocol, observabilityService: any ObservabilityServiceProtocol = NullObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, serviceName: String, account: String) async -> AppleServiceDomainState {
        var next = state
        do {
            next.keychainPassword = try await service.read(service: serviceName, account: account)
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.keychainPassword = nil
            next.lastError = String(describing: error)
        }
        return next
    }
}
