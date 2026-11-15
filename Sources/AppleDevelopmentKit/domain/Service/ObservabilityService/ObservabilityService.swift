struct ObservabilityService: Sendable {
    func log(_ error: any Error) {
        #if DEBUG
        fputs("AppleDevelopmentKit: \(error)\n", stderr)
        #endif
    }
}
