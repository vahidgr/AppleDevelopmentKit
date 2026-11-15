import Testing
@testable import AppleDevelopmentKit

@Suite struct ListICloudDocumentsTests {
    @Test func storesDocumentURLs() async {
        let urls = [URL(fileURLWithPath: "/tmp/a.pages")]
        let mock = MockICloudDocumentService(listResult: .success(urls), copyResult: .failure(.failed), downloadResult: .success(()))
        let state = await ListICloudDocuments(service: mock).execute(AppleServiceDomainState(), containerIdentifier: nil)
        #expect(state.iCloudDocumentURLs == urls)
        #expect(state.lastError == nil)
    }
    @Test func clearsResultsWhenListingFails() async {
        let mock = MockICloudDocumentService(listResult: .failure(.failed), copyResult: .failure(.failed), downloadResult: .success(()))
        let state = await ListICloudDocuments(service: mock).execute(AppleServiceDomainState(), containerIdentifier: nil)
        #expect(state.iCloudDocumentURLs.isEmpty)
        #expect(state.lastError != nil)
    }
}
