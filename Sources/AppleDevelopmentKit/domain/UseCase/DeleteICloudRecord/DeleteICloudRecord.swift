struct DeleteICloudRecord: Sendable {
    private let service: any CloudRecordServiceProtocol
    private let observabilityService: any ObservabilityServiceProtocol
    init(service: any CloudRecordServiceProtocol, observabilityService: any ObservabilityServiceProtocol = NullObservabilityService()) {
        self.service = service
        self.observabilityService = observabilityService
    }
    @concurrent func execute(_ state: AppleServiceDomainState, scope: ICloudDatabaseScope, recordType: String, recordName: String) async -> AppleServiceDomainState {
        var next = state
        do {
            try await service.delete(scope: scope, recordType: recordType, recordName: recordName)
            next.iCloudRecordPayload = nil
            next.iCloudRecordIdentifier = nil
            next.lastError = nil
        } catch {
            observabilityService.log(error)
            next.lastError = String(describing: error)
        }
        return next
    }
}
