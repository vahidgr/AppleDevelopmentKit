import Foundation

protocol MessageComposeServiceProtocol: Sendable {
    func makeURL(recipient: String, body: String?) throws -> URL
}
