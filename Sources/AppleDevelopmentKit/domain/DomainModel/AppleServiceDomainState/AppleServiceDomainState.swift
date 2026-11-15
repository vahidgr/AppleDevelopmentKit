import Foundation

public struct AppleServiceDomainState: Sendable, Equatable {
    public internal(set) var faceTimeCallURL: URL?
    public internal(set) var iCloudAccountStatus: String?
    public internal(set) var calendarEventIdentifier: String?
    public internal(set) var reminderIdentifier: String?
    public internal(set) var keychainPassword: Data?
    public internal(set) var iCloudDocumentURLs: [URL]
    public internal(set) var lastFileURL: URL?
    public internal(set) var exportedPDFURL: URL?
    public internal(set) var messagesComposeURL: URL?
    public internal(set) var lastOpenedURL: URL?
    public internal(set) var iCloudRecordIdentifier: String?
    public internal(set) var iCloudRecordPayload: Data?
    public internal(set) var lastError: String?

    public init(
        faceTimeCallURL: URL? = nil,
        iCloudAccountStatus: String? = nil,
        calendarEventIdentifier: String? = nil,
        reminderIdentifier: String? = nil,
        keychainPassword: Data? = nil,
        iCloudDocumentURLs: [URL] = [],
        lastFileURL: URL? = nil,
        exportedPDFURL: URL? = nil,
        messagesComposeURL: URL? = nil,
        lastOpenedURL: URL? = nil,
        iCloudRecordIdentifier: String? = nil,
        iCloudRecordPayload: Data? = nil,
        lastError: String? = nil
    ) {
        self.faceTimeCallURL = faceTimeCallURL
        self.iCloudAccountStatus = iCloudAccountStatus
        self.calendarEventIdentifier = calendarEventIdentifier
        self.reminderIdentifier = reminderIdentifier
        self.keychainPassword = keychainPassword
        self.iCloudDocumentURLs = iCloudDocumentURLs
        self.lastFileURL = lastFileURL
        self.exportedPDFURL = exportedPDFURL
        self.messagesComposeURL = messagesComposeURL
        self.lastOpenedURL = lastOpenedURL
        self.iCloudRecordIdentifier = iCloudRecordIdentifier
        self.iCloudRecordPayload = iCloudRecordPayload
        self.lastError = lastError
    }
}
