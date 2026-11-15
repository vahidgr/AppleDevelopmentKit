import Foundation

public protocol AppURLServiceProtocol: Sendable {
    func open(_ url: URL) async throws -> Bool
}
