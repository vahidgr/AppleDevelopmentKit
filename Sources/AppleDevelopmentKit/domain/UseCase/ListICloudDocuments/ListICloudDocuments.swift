struct ListICloudDocuments: Sendable {
    private let service: any ICloudDocumentServiceProtocol
    private let observabilityService: ObservabilityService
    init(service: any ICloudDocumentServiceProtocol = ICloudDocumentService(), observabilityService: ObservabilityService = ObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, containerIdentifier: String?) async -> AppleServiceDomainState {
        var next = state
        do {
            next.iCloudDocumentURLs = try await service.list(containerIdentifier: containerIdentifier)
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.iCloudDocumentURLs = []
            next.lastError = String(describing: error)
        }
        return next
    }
}
