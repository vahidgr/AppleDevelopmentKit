import Observation

@globalActor
public actor AppleServiceActor {
    public static let shared = AppleServiceActor()
}

@AppleServiceActor
@Observable
public final class AppleServiceStateContainer {
    public private(set) var state = AppleServiceDomainState()
    private let useCases: AppleServiceUseCaseContainer

    public init() {
        useCases = AppleServiceUseCaseContainer()
    }

    public func send(_ action: AppleServiceAction) async {
        state = await useCases.send(state, action)
    }
}
