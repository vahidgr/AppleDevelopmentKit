import Foundation

struct DownloadICloudFile: Sendable {
    private let service: any ICloudDocumentServiceProtocol
    private let observabilityService: ObservabilityService
    init(service: any ICloudDocumentServiceProtocol = ICloudDocumentService(), observabilityService: ObservabilityService = ObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, url: URL) async -> AppleServiceDomainState {
        var next = state
        do {
            try await service.download(url: url)
            next.lastFileURL = url
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.lastFileURL = nil
            next.lastError = String(describing: error)
        }
        return next
    }
}
