struct MakeFaceTimeCallURL: Sendable {
    private let faceTimeCallService: any FaceTimeCallServiceProtocol
    private let observabilityService: any ObservabilityServiceProtocol

    init(
        faceTimeCallService: any FaceTimeCallServiceProtocol,
        observabilityService: any ObservabilityServiceProtocol = NullObservabilityService()
    ) {
        self.faceTimeCallService = faceTimeCallService
        self.observabilityService = observabilityService
    }

    @concurrent func execute(
        _ existingState: AppleServiceDomainState,
        destination: String,
        type: FaceTimeCallType
    ) async -> AppleServiceDomainState {
        var newState = existingState
        do {
            newState.faceTimeCallURL = try faceTimeCallService.makeURL(destination: destination, type: type)
            newState.lastError = nil
        } catch {
            observabilityService.log(error)
            newState.faceTimeCallURL = nil
            newState.lastError = String(describing: error)
        }
        return newState
    }
}
