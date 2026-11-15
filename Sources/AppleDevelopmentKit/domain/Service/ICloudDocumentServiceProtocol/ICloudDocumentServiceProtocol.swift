import Foundation

public protocol ICloudDocumentServiceProtocol: Sendable {
    func list(containerIdentifier: String?) async throws -> [URL]
    func copy(sourceURL: URL, fileName: String, containerIdentifier: String?) async throws -> URL
    func download(url: URL) async throws
}
