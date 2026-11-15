struct ClearKeychainPassword: Sendable {
    @concurrent func execute(_ state: AppleServiceDomainState) async -> AppleServiceDomainState {
        var next = state
        next.keychainPassword = nil
        next.lastError = nil
        return next
    }
}
