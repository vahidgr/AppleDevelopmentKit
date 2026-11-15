struct AppleServiceUseCaseContainer: Sendable {
    private let makeFaceTimeCallURL: MakeFaceTimeCallURL
    private let checkICloudAccount: CheckICloudAccount

    init(
        makeFaceTimeCallURL: MakeFaceTimeCallURL = MakeFaceTimeCallURL(),
        checkICloudAccount: CheckICloudAccount = CheckICloudAccount()
    ) {
        self.makeFaceTimeCallURL = makeFaceTimeCallURL
        self.checkICloudAccount = checkICloudAccount
    }

    func send(_ state: AppleServiceDomainState, _ action: AppleServiceAction) async -> AppleServiceDomainState {
        switch action {
        case let .makeFaceTimeCallURL(destination, type):
            await makeFaceTimeCallURL.execute(state, destination: destination, type: type)
        case .checkICloudAccount:
            await checkICloudAccount.execute(state)
        }
    }
}
