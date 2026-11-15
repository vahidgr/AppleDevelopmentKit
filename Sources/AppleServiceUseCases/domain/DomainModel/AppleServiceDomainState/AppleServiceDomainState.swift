import Foundation

public struct AppleServiceDomainState: Sendable, Equatable {
    public internal(set) var faceTimeCallURL: URL?
    public internal(set) var iCloudAccountStatus: String?
    public internal(set) var lastError: String?

    public init(faceTimeCallURL: URL? = nil, iCloudAccountStatus: String? = nil, lastError: String? = nil) {
        self.faceTimeCallURL = faceTimeCallURL
        self.iCloudAccountStatus = iCloudAccountStatus
        self.lastError = lastError
    }
}
