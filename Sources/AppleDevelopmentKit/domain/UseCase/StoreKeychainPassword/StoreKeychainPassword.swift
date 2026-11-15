import Foundation

struct StoreKeychainPassword: Sendable {
    private let service: any KeychainPasswordServiceProtocol
    private let observabilityService: ObservabilityService
    init(service: any KeychainPasswordServiceProtocol = KeychainPasswordService(), observabilityService: ObservabilityService = ObservabilityService()) {
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
