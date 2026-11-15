import Testing
import AppleDevelopmentKit

@AppleServiceActor
struct AppleServiceStateContainerTests {
    private let stateContainer = AppleServiceStateContainer(services: makeMockAppleDevelopmentKitServices())

    @Test func makesVideoCallURL() async {
        await stateContainer.send(.makeFaceTimeCallURL(destination: "person@example.com", type: .video))
        #expect(stateContainer.state.faceTimeCallURL?.absoluteString == "facetime://person@example.com")
        #expect(stateContainer.state.lastError == nil)
    }

    @Test func makesAudioCallURL() async {
        await stateContainer.send(.makeFaceTimeCallURL(destination: "+14155550100", type: .audio))
        #expect(stateContainer.state.faceTimeCallURL?.absoluteString == "facetime-audio://+14155550100")
    }

    @Test func reportsInvalidDestinationsInState() async {
        await stateContainer.send(.makeFaceTimeCallURL(destination: "  ", type: .video))
        #expect(stateContainer.state.faceTimeCallURL == nil)
        #expect(stateContainer.state.lastError != nil)

        await stateContainer.send(.makeFaceTimeCallURL(destination: "invalid recipient", type: .audio))
        #expect(stateContainer.state.faceTimeCallURL == nil)
        #expect(stateContainer.state.lastError != nil)
    }
}
