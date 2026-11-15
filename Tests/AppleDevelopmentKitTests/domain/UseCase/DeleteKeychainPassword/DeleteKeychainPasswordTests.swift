import Testing
@testable import AppleDevelopmentKit

@Suite struct DeleteKeychainPasswordTests {
    @Test func deletesSecretAndClearsState() async {
        let initial = AppleServiceDomainState(keychainPassword: Data([1]))
        let state = await DeleteKeychainPassword(service: MockKeychainPasswordService(readResult: .failure(.failed), writeResult: .success(())))
            .execute(initial, serviceName: "app", account: "user")
        #expect(state.keychainPassword == nil)
        #expect(state.lastError == nil)
    }
    @Test func reportsDeleteFailure() async {
        let state = await DeleteKeychainPassword(service: MockKeychainPasswordService(readResult: .failure(.failed), writeResult: .failure(.failed)))
            .execute(AppleServiceDomainState(), serviceName: "app", account: "user")
        #expect(state.lastError != nil)
    }
}
