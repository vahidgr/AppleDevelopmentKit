import Foundation

public protocol MessageComposeServiceProtocol: Sendable {
    func makeURL(recipient: String, body: String?) throws -> URL
}
