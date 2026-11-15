import Testing
@testable import AppleDevelopmentKit

@Suite struct DownloadICloudFileTests {
    @Test func recordsDownloadURL() async {
        let url = URL(fileURLWithPath: "/tmp/cloud/report.pages")
        let mock = MockICloudDocumentService(listResult: .success([]), copyResult: .failure(.failed), downloadResult: .success(()))
        let state = await DownloadICloudFile(service: mock).execute(AppleServiceDomainState(), url: url)
        #expect(state.lastFileURL == url)
        #expect(state.lastError == nil)
    }
    @Test func reportsDownloadFailure() async {
        let url = URL(fileURLWithPath: "/tmp/cloud/report.pages")
        let mock = MockICloudDocumentService(listResult: .success([]), copyResult: .failure(.failed), downloadResult: .failure(.failed))
        let state = await DownloadICloudFile(service: mock).execute(AppleServiceDomainState(), url: url)
        #expect(state.lastFileURL == nil)
        #expect(state.lastError != nil)
    }
}
