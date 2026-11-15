import Testing
@testable import AppleDevelopmentKit

@Suite struct MakeMessageComposeURLTests {
    @Test func storesMessageComposerURL() async {
        let state = await MakeMessageComposeURL(service: MockMessageComposeService()).execute(AppleServiceDomainState(), recipient: "+15550100", body: "hi")
        #expect(state.messagesComposeURL?.scheme == "sms")
        #expect(state.lastError == nil)
    }
    @Test func reportsInvalidRecipient() async {
        let state = await MakeMessageComposeURL(service: MockMessageComposeService()).execute(AppleServiceDomainState(), recipient: "invalid number", body: nil)
        #expect(state.messagesComposeURL == nil)
        #expect(state.lastError != nil)
    }
}
