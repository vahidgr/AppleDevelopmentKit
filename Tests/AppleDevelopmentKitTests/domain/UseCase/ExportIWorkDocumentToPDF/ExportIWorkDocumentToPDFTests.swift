import Foundation
import Testing
@testable import AppleDevelopmentKit

@Suite struct ExportIWorkDocumentToPDFTests {
    @Test func storesExportedPDFURL() async {
        let output = URL(fileURLWithPath: "/tmp/export.pdf")
        let useCase = ExportIWorkDocumentToPDF(service: MockIWorkDocumentExportService(result: .success(output)))
        let state = await useCase.execute(
            AppleServiceDomainState(), documentURL: URL(fileURLWithPath: "/tmp/file.pages"),
            fileName: "file.pages", credentials: .init(teamIdentifier: "team", keyIdentifier: "key", privateKeyPEM: "pem")
        )
        #expect(state.exportedPDFURL == output)
        #expect(state.lastError == nil)
    }

    @Test func reportsExportFailure() async {
        let useCase = ExportIWorkDocumentToPDF(service: MockIWorkDocumentExportService(result: .failure(.failed)))
        let state = await useCase.execute(
            AppleServiceDomainState(), documentURL: URL(fileURLWithPath: "/tmp/file.pages"),
            fileName: "file.pages", credentials: .init(teamIdentifier: "team", keyIdentifier: "key", privateKeyPEM: "pem")
        )
        #expect(state.exportedPDFURL == nil)
        #expect(state.lastError != nil)
    }
}
