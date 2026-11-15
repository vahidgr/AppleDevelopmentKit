import Foundation

struct ExportIWorkDocumentToPDF: Sendable {
    private let service: any IWorkDocumentExportServiceProtocol
    private let observabilityService: any ObservabilityServiceProtocol
    init(service: any IWorkDocumentExportServiceProtocol, observabilityService: any ObservabilityServiceProtocol = NullObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, documentURL: URL, fileName: String, credentials: IWorkExportCredentials) async -> AppleServiceDomainState {
        var next = state
        do {
            next.exportedPDFURL = try await service.exportPDF(documentURL: documentURL, fileName: fileName, credentials: credentials)
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.exportedPDFURL = nil
            next.lastError = String(describing: error)
        }
        return next
    }
}
