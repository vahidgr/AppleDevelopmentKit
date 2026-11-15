import Foundation

protocol CloudRecordServiceProtocol: Sendable {
    func save(scope: ICloudDatabaseScope, recordType: String, recordName: String, payload: Data) async throws
    func read(scope: ICloudDatabaseScope, recordType: String, recordName: String) async throws -> Data
    func delete(scope: ICloudDatabaseScope, recordType: String, recordName: String) async throws
}
