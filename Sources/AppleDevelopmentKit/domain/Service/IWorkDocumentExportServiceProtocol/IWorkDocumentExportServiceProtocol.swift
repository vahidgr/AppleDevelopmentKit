import Foundation

protocol IWorkDocumentExportServiceProtocol: Sendable {
    func exportPDF(documentURL: URL, fileName: String, credentials: IWorkExportCredentials) async throws -> URL
}
