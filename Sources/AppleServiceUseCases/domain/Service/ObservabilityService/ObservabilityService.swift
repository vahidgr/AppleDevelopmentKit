struct ObservabilityService: Sendable {
    func log(_ error: any Error) {
        #if DEBUG
        fputs("AppleServiceUseCases: \(error)\n", stderr)
        #endif
    }
}
