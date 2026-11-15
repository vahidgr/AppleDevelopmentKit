struct CheckICloudAccount: Sendable {
    private let iCloudAccountService: any ICloudAccountServiceProtocol
    private let observabilityService: any ObservabilityServiceProtocol

    init(
        iCloudAccountService: any ICloudAccountServiceProtocol,
        observabilityService: any ObservabilityServiceProtocol = NullObservabilityService()
    ) {
        self.iCloudAccountService = iCloudAccountService
        self.observabilityService = observabilityService
    }

    @concurrent func execute(_ existingState: AppleServiceDomainState) async -> AppleServiceDomainState {
        var newState = existingState
        do {
            newState.iCloudAccountStatus = try await iCloudAccountService.accountStatus()
            newState.lastError = nil
        } catch {
            observabilityService.log(error)
            newState.iCloudAccountStatus = nil
            newState.lastError = String(describing: error)
        }
        return newState
    }
}
