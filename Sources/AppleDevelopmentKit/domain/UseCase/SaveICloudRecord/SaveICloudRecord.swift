import Foundation

struct SaveICloudRecord: Sendable {
    private let service: any CloudRecordServiceProtocol
    private let observabilityService: any ObservabilityServiceProtocol
    init(service: any CloudRecordServiceProtocol, observabilityService: any ObservabilityServiceProtocol = NullObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, scope: ICloudDatabaseScope, recordType: String, recordName: String, payload: Data) async -> AppleServiceDomainState {
        var next = state
        do {
            try await service.save(scope: scope, recordType: recordType, recordName: recordName, payload: payload)
            next.iCloudRecordIdentifier = recordName
            next.iCloudRecordPayload = nil
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.iCloudRecordIdentifier = nil
            next.lastError = String(describing: error)
        }
        return next
    }
}
