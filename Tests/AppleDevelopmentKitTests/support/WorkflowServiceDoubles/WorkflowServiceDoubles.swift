import Foundation
@testable import AppleDevelopmentKit

enum WorkflowServiceFailure: Error { case failed }

struct MockFaceTimeCallService: FaceTimeCallServiceProtocol {
    func makeURL(destination: String, type: FaceTimeCallType) throws -> URL {
        guard destination == destination.trimmingCharacters(in: .whitespacesAndNewlines), !destination.isEmpty else {
            throw WorkflowServiceFailure.failed
        }
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "@+.-()#*"))
        guard destination.unicodeScalars.allSatisfy(allowed.contains) else { throw WorkflowServiceFailure.failed }
        let scheme = type == .audio ? "facetime-audio" : "facetime"
        guard let url = URL(string: "\(scheme)://\(destination)") else { throw WorkflowServiceFailure.failed }
        return url
    }
}

struct MockObservabilityService: ObservabilityServiceProtocol {
    func log(_ error: any Error) {}
}

struct MockCalendarEventService: CalendarEventServiceProtocol {
    let result: Result<String, WorkflowServiceFailure>
    func create(title: String, startDate: Date, endDate: Date) async throws -> String { try result.get() }
}

struct MockReminderService: ReminderServiceProtocol {
    let result: Result<String, WorkflowServiceFailure>
    func create(title: String, dueDate: Date?) async throws -> String { try result.get() }
}

struct MockKeychainPasswordService: KeychainPasswordServiceProtocol {
    let readResult: Result<Data, WorkflowServiceFailure>
    let writeResult: Result<Void, WorkflowServiceFailure>
    func store(service: String, account: String, password: Data) async throws { try writeResult.get() }
    func read(service: String, account: String) async throws -> Data { try readResult.get() }
    func delete(service: String, account: String) async throws { try writeResult.get() }
}

struct MockICloudDocumentService: ICloudDocumentServiceProtocol {
    let listResult: Result<[URL], WorkflowServiceFailure>
    let copyResult: Result<URL, WorkflowServiceFailure>
    let downloadResult: Result<Void, WorkflowServiceFailure>
    func list(containerIdentifier: String?) async throws -> [URL] { try listResult.get() }
    func copy(sourceURL: URL, fileName: String, containerIdentifier: String?) async throws -> URL { try copyResult.get() }
    func download(url: URL) async throws { try downloadResult.get() }
}

struct MockIWorkDocumentExportService: IWorkDocumentExportServiceProtocol {
    let result: Result<URL, WorkflowServiceFailure>
    func exportPDF(documentURL: URL, fileName: String, credentials: IWorkExportCredentials) async throws -> URL { try result.get() }
}

struct MockAppURLService: AppURLServiceProtocol {
    let result: Result<Bool, WorkflowServiceFailure>
    func open(_ url: URL) async throws -> Bool { try result.get() }
}

struct MockCloudRecordService: CloudRecordServiceProtocol {
    let saveResult: Result<Void, WorkflowServiceFailure>
    let readResult: Result<Data, WorkflowServiceFailure>
    let deleteResult: Result<Void, WorkflowServiceFailure>
    func save(scope: ICloudDatabaseScope, recordType: String, recordName: String, payload: Data) async throws { try saveResult.get() }
    func read(scope: ICloudDatabaseScope, recordType: String, recordName: String) async throws -> Data { try readResult.get() }
    func delete(scope: ICloudDatabaseScope, recordType: String, recordName: String) async throws { try deleteResult.get() }
}

struct MockICloudAccountServiceForContainer: ICloudAccountServiceProtocol {
    func accountStatus() async throws -> String { "available" }
}

func makeMockAppleDevelopmentKitServices() -> AppleDevelopmentKitServices {
    let fileURL = URL(fileURLWithPath: "/tmp/document.pages")
    return AppleDevelopmentKitServices(
        faceTimeCall: MockFaceTimeCallService(),
        iCloudAccount: MockICloudAccountServiceForContainer(),
        calendarEvent: MockCalendarEventService(result: .success("event")),
        reminder: MockReminderService(result: .success("reminder")),
        keychainPassword: MockKeychainPasswordService(readResult: .success(Data([7])), writeResult: .success(())),
        iCloudDocument: MockICloudDocumentService(listResult: .success([fileURL]), copyResult: .success(fileURL), downloadResult: .success(())),
        iWorkDocumentExport: MockIWorkDocumentExportService(result: .success(fileURL)),
        messageCompose: MockMessageComposeService(),
        appURL: MockAppURLService(result: .success(true)),
        cloudRecord: MockCloudRecordService(saveResult: .success(()), readResult: .success(Data([8])), deleteResult: .success(())),
        observability: MockObservabilityService()
    )
}

struct MockMessageComposeService: MessageComposeServiceProtocol {
    func makeURL(recipient: String, body: String?) throws -> URL {
        guard !recipient.contains(" ") else { throw WorkflowServiceFailure.failed }
        return URL(string: "sms:\(recipient)")!
    }
}
