public protocol ICloudAccountServiceProtocol: Sendable {
    func accountStatus() async throws -> String
}
