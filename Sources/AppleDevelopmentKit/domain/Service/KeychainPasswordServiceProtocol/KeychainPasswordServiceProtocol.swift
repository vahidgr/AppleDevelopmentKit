import Foundation

protocol KeychainPasswordServiceProtocol: Sendable {
    func store(service: String, account: String, password: Data) async throws
    func read(service: String, account: String) async throws -> Data
    func delete(service: String, account: String) async throws
}
