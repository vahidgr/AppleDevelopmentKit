import Foundation

struct CopyFileToICloud: Sendable {
    private let service: any ICloudDocumentServiceProtocol
    private let observabilityService: ObservabilityService
    init(service: any ICloudDocumentServiceProtocol = ICloudDocumentService(), observabilityService: ObservabilityService = ObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, sourceURL: URL, fileName: String, containerIdentifier: String?) async -> AppleServiceDomainState {
        var next = state
        do {
            next.lastFileURL = try await service.copy(sourceURL: sourceURL, fileName: fileName, containerIdentifier: containerIdentifier)
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.lastFileURL = nil
            next.lastError = String(describing: error)
        }
        return next
    }
}
