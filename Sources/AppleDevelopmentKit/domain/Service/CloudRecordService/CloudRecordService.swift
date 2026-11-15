@preconcurrency import AppleServices
import Foundation

struct CloudRecordService: CloudRecordServiceProtocol {
    private let containerIdentifier: String?
    init(containerIdentifier: String? = nil) { self.containerIdentifier = containerIdentifier }

    func save(scope: ICloudDatabaseScope, recordType: String, recordName: String, payload: Data) async throws {
        guard !recordType.isEmpty, !recordName.isEmpty else { throw Failure.invalidRecordIdentity }
        let id = CKRecord.ID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: id)
        record["payload"] = payload as CKRecordValue
        _ = try await database(scope).save(record)
    }

    func read(scope: ICloudDatabaseScope, recordType: String, recordName: String) async throws -> Data {
        guard !recordType.isEmpty, !recordName.isEmpty else { throw Failure.invalidRecordIdentity }
        let record = try await database(scope).record(for: CKRecord.ID(recordName: recordName))
        guard record.recordType == recordType, let data = record["payload"] as? Data else { throw Failure.invalidPayload }
        return data
    }

    func delete(scope: ICloudDatabaseScope, recordType: String, recordName: String) async throws {
        guard !recordType.isEmpty, !recordName.isEmpty else { throw Failure.invalidRecordIdentity }
        _ = try await database(scope).deleteRecord(withID: CKRecord.ID(recordName: recordName))
    }

    private func database(_ scope: ICloudDatabaseScope) -> CKDatabase {
        let container = containerIdentifier.map(CKContainer.init(identifier:)) ?? CKContainer.default()
        switch scope {
        case .private: return container.privateCloudDatabase
        case .public: return container.publicCloudDatabase
        case .shared: return container.sharedCloudDatabase
        }
    }

    enum Failure: Error, Equatable { case invalidRecordIdentity, invalidPayload }
}
