import Foundation
@testable import AppleDevelopmentKit

enum WorkflowServiceFailure: Error { case failed }

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
