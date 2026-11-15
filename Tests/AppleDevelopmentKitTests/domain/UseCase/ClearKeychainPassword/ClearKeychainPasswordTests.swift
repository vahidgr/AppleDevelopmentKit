import Foundation
import Testing
@testable import AppleDevelopmentKit

@Suite struct ClearKeychainPasswordTests {
    @Test func clearsPasswordFromObservableState() async {
        let initial = AppleServiceDomainState(keychainPassword: Data([4, 2]), lastError: "previous")
        let next = await ClearKeychainPassword().execute(initial)
        #expect(next.keychainPassword == nil)
        #expect(next.lastError == nil)
    }
}
