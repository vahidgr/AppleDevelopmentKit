import Foundation

/// Documents which operations are available as reusable workflows and which require
/// direct use of a re-exported Apple framework or host-app integration.
public struct AppleServiceCapability: Sendable, Hashable, Identifiable {
    public enum Access: String, Sendable, Hashable {
        case useCase
        case nativeFramework
        case hostAppIntegration
        case unavailable
    }

    public let id: String
    public let name: String
    public let access: Access
    public let frameworks: [String]
    public let summary: String

    public init(id: String, name: String, access: Access, frameworks: [String], summary: String) {
        self.id = id
        self.name = name
        self.access = access
        self.frameworks = frameworks
        self.summary = summary
    }
}
