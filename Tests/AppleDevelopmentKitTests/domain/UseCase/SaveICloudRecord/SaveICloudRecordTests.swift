import Foundation
import Testing
@testable import AppleDevelopmentKit

@Suite struct SaveICloudRecordTests {
    @Test func storesSavedRecordIdentifier() async {
        let mock = MockCloudRecordService(saveResult: .success(()), readResult: .failure(.failed), deleteResult: .success(()))
        let state = await SaveICloudRecord(service: mock).execute(AppleServiceDomainState(), scope: .private, recordType: "Note", recordName: "one", payload: Data([1]))
        #expect(state.iCloudRecordIdentifier == "one")
        #expect(state.lastError == nil)
    }
    @Test func reportsSaveFailure() async {
        let mock = MockCloudRecordService(saveResult: .failure(.failed), readResult: .failure(.failed), deleteResult: .success(()))
        let state = await SaveICloudRecord(service: mock).execute(AppleServiceDomainState(), scope: .private, recordType: "Note", recordName: "one", payload: Data([1]))
        #expect(state.iCloudRecordIdentifier == nil)
        #expect(state.lastError != nil)
    }
}
