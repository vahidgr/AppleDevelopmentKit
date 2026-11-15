import Foundation

struct ReadICloudRecord: Sendable {
    private let service: any CloudRecordServiceProtocol
    private let observabilityService: any ObservabilityServiceProtocol
    init(service: any CloudRecordServiceProtocol, observabilityService: any ObservabilityServiceProtocol = NullObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, scope: ICloudDatabaseScope, recordType: String, recordName: String) async -> AppleServiceDomainState {
        var next = state
        do {
            next.iCloudRecordPayload = try await service.read(scope: scope, recordType: recordType, recordName: recordName)
            next.iCloudRecordIdentifier = recordName
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.iCloudRecordPayload = nil
            next.iCloudRecordIdentifier = nil
            next.lastError = String(describing: error)
        }
        return next
    }
}
