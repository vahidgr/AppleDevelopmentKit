/// Credentials for Apple's iWork Document Export API. Keep the private key in a secure
/// secret store and never commit it to a consuming app or package repository.
public struct IWorkExportCredentials: Sendable, Equatable {
    public let teamIdentifier: String
    public let keyIdentifier: String
    public let privateKeyPEM: String

    public init(teamIdentifier: String, keyIdentifier: String, privateKeyPEM: String) {
        self.teamIdentifier = teamIdentifier
        self.keyIdentifier = keyIdentifier
        self.privateKeyPEM = privateKeyPEM
    }
}
