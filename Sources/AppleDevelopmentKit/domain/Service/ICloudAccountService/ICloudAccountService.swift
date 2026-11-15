import AppleServices

protocol ICloudAccountServiceProtocol: Sendable {
    func accountStatus() async throws -> String
}

struct ICloudAccountService: ICloudAccountServiceProtocol {
    func accountStatus() async throws -> String {
        let status = try await CKContainer.default().accountStatus()
        return switch status {
        case .available: "available"
        case .noAccount: "noAccount"
        case .restricted: "restricted"
        case .temporarilyUnavailable: "temporarilyUnavailable"
        case .couldNotDetermine: "couldNotDetermine"
        @unknown default: "unknown"
        }
    }
}
