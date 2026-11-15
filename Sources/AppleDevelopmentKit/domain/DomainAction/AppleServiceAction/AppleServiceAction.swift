import Foundation

public enum AppleServiceAction: Sendable {
    case makeFaceTimeCallURL(destination: String, type: FaceTimeCallType)
    case checkICloudAccount
    case createCalendarEvent(title: String, startDate: Date, endDate: Date)
    case createReminder(title: String, dueDate: Date?)
    case storeKeychainPassword(service: String, account: String, password: Data)
    case readKeychainPassword(service: String, account: String)
    case deleteKeychainPassword(service: String, account: String)
    case clearKeychainPassword
    case listICloudDocuments(containerIdentifier: String?)
    case copyFileToICloud(sourceURL: URL, fileName: String, containerIdentifier: String?)
    case downloadICloudFile(URL)
    case exportIWorkDocumentToPDF(documentURL: URL, fileName: String, credentials: IWorkExportCredentials)
    case makeMessageComposeURL(recipient: String, body: String?)
    case openAppURL(URL)
    case saveICloudRecord(scope: ICloudDatabaseScope, recordType: String, recordName: String, payload: Data)
    case readICloudRecord(scope: ICloudDatabaseScope, recordType: String, recordName: String)
    case deleteICloudRecord(scope: ICloudDatabaseScope, recordType: String, recordName: String)
}
