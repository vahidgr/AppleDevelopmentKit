import Foundation

struct OpenAppURL: Sendable {
    private let service: any AppURLServiceProtocol
    private let observabilityService: ObservabilityService
    init(service: any AppURLServiceProtocol = AppURLService(), observabilityService: ObservabilityService = ObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, url: URL) async -> AppleServiceDomainState {
        var next = state
        do {
            guard try await service.open(url) else { throw Failure.systemDeclinedURL }
            next.lastOpenedURL = url
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.lastOpenedURL = nil
            next.lastError = String(describing: error)
        }
        return next
    }

    enum Failure: Error, Equatable { case systemDeclinedURL }
}
