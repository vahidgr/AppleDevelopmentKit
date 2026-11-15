import Foundation

protocol AppURLServiceProtocol: Sendable {
    func open(_ url: URL) async throws -> Bool
}
