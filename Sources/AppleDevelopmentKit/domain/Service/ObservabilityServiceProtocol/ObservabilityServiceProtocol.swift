public protocol ObservabilityServiceProtocol: Sendable {
    func log(_ error: any Error)
}

struct NullObservabilityService: ObservabilityServiceProtocol {
    func log(_ error: any Error) {}
}
