import Foundation
import Testing
@testable import AppleDevelopmentKit

@Suite struct StoreKeychainPasswordTests {
    @Test func storesPasswordWithoutCopyingSecretIntoState() async {
        let state = await StoreKeychainPassword(service: MockKeychainPasswordService(readResult: .failure(.failed), writeResult: .success(())))
            .execute(AppleServiceDomainState(), serviceName: "app", account: "user", password: Data([1, 2]))
        #expect(state.keychainPassword == nil)
        #expect(state.lastError == nil)
    }
    @Test func reportsStoreFailure() async {
        let state = await StoreKeychainPassword(service: MockKeychainPasswordService(readResult: .failure(.failed), writeResult: .failure(.failed)))
            .execute(AppleServiceDomainState(), serviceName: "app", account: "user", password: Data([1]))
        #expect(state.lastError != nil)
    }
}
