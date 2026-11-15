import Foundation
import Testing
@testable import AppleDevelopmentKit

@Suite struct OpenAppURLTests {
    @Test func recordsSuccessfullyOpenedRoute() async {
        let url = URL(string: "myapp://item/42?instruction=show")!
        let state = await OpenAppURL(service: MockAppURLService(result: .success(true))).execute(AppleServiceDomainState(), url: url)
        #expect(state.lastOpenedURL == url)
        #expect(state.lastError == nil)
    }
    @Test func reportsSystemDecline() async {
        let state = await OpenAppURL(service: MockAppURLService(result: .success(false))).execute(AppleServiceDomainState(), url: URL(string: "https://example.com")!)
        #expect(state.lastOpenedURL == nil)
        #expect(state.lastError != nil)
    }
    @Test func reportsOpeningFailure() async {
        let state = await OpenAppURL(service: MockAppURLService(result: .failure(.failed))).execute(AppleServiceDomainState(), url: URL(string: "https://example.com")!)
        #expect(state.lastOpenedURL == nil)
        #expect(state.lastError != nil)
    }
}
