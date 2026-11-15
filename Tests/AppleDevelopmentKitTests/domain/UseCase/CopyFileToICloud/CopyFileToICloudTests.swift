import Testing
@testable import AppleDevelopmentKit

@Suite struct CopyFileToICloudTests {
    @Test func storesCopiedFileURL() async {
        let destination = URL(fileURLWithPath: "/tmp/cloud/report.pages")
        let mock = MockICloudDocumentService(listResult: .success([]), copyResult: .success(destination), downloadResult: .success(()))
        let state = await CopyFileToICloud(service: mock).execute(AppleServiceDomainState(), sourceURL: URL(fileURLWithPath: "/tmp/report.pages"), fileName: "report.pages", containerIdentifier: nil)
        #expect(state.lastFileURL == destination)
        #expect(state.lastError == nil)
    }
    @Test func reportsCopyFailure() async {
        let mock = MockICloudDocumentService(listResult: .success([]), copyResult: .failure(.failed), downloadResult: .success(()))
        let state = await CopyFileToICloud(service: mock).execute(AppleServiceDomainState(), sourceURL: URL(fileURLWithPath: "/tmp/report.pages"), fileName: "report.pages", containerIdentifier: nil)
        #expect(state.lastFileURL == nil)
        #expect(state.lastError != nil)
    }
}
