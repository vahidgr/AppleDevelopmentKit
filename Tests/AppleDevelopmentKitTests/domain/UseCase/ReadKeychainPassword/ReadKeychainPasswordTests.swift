import Foundation
import Testing
@testable import AppleDevelopmentKit

@Suite struct ReadKeychainPasswordTests {
    @Test func returnsPasswordInState() async {
        let state = await ReadKeychainPassword(service: MockKeychainPasswordService(readResult: .success(Data([9])), writeResult: .success(())))
            .execute(AppleServiceDomainState(), serviceName: "app", account: "user")
        #expect(state.keychainPassword == Data([9]))
        #expect(state.lastError == nil)
    }
    @Test func reportsMissingPassword() async {
        let state = await ReadKeychainPassword(service: MockKeychainPasswordService(readResult: .failure(.failed), writeResult: .success(())))
            .execute(AppleServiceDomainState(), serviceName: "app", account: "user")
        #expect(state.keychainPassword == nil)
        #expect(state.lastError != nil)
    }
}
