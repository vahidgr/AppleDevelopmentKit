import Foundation

/// Concrete service implementations supplied by a data-layer package such as AppleServices.
public struct AppleDevelopmentKitServices: Sendable {
    public let faceTimeCall: any FaceTimeCallServiceProtocol
    public let iCloudAccount: any ICloudAccountServiceProtocol
    public let calendarEvent: any CalendarEventServiceProtocol
    public let reminder: any ReminderServiceProtocol
    public let keychainPassword: any KeychainPasswordServiceProtocol
    public let iCloudDocument: any ICloudDocumentServiceProtocol
    public let iWorkDocumentExport: any IWorkDocumentExportServiceProtocol
    public let messageCompose: any MessageComposeServiceProtocol
    public let appURL: any AppURLServiceProtocol
    public let cloudRecord: any CloudRecordServiceProtocol
    public let observability: any ObservabilityServiceProtocol

    public init(
        faceTimeCall: any FaceTimeCallServiceProtocol,
        iCloudAccount: any ICloudAccountServiceProtocol,
        calendarEvent: any CalendarEventServiceProtocol,
        reminder: any ReminderServiceProtocol,
        keychainPassword: any KeychainPasswordServiceProtocol,
        iCloudDocument: any ICloudDocumentServiceProtocol,
        iWorkDocumentExport: any IWorkDocumentExportServiceProtocol,
        messageCompose: any MessageComposeServiceProtocol,
        appURL: any AppURLServiceProtocol,
        cloudRecord: any CloudRecordServiceProtocol,
        observability: any ObservabilityServiceProtocol
    ) {
        self.faceTimeCall = faceTimeCall
        self.iCloudAccount = iCloudAccount
        self.calendarEvent = calendarEvent
        self.reminder = reminder
        self.keychainPassword = keychainPassword
        self.iCloudDocument = iCloudDocument
        self.iWorkDocumentExport = iWorkDocumentExport
        self.messageCompose = messageCompose
        self.appURL = appURL
        self.cloudRecord = cloudRecord
        self.observability = observability
    }
}
