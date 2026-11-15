struct MakeFaceTimeCallURL: Sendable {
    private let faceTimeCallService: FaceTimeCallService
    private let observabilityService: ObservabilityService

    init(
        faceTimeCallService: FaceTimeCallService = FaceTimeCallService(),
        observabilityService: ObservabilityService = ObservabilityService()
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
