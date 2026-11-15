import Foundation
import Testing
@testable import AppleDevelopmentKit

@Suite struct ReadICloudRecordTests {
    @Test func storesLoadedPayload() async {
        let mock = MockCloudRecordService(saveResult: .success(()), readResult: .success(Data([2, 3])), deleteResult: .success(()))
        let state = await ReadICloudRecord(service: mock).execute(AppleServiceDomainState(), scope: .private, recordType: "Note", recordName: "one")
        #expect(state.iCloudRecordIdentifier == "one")
        #expect(state.iCloudRecordPayload == Data([2, 3]))
        #expect(state.lastError == nil)
    }
    @Test func reportsReadFailure() async {
        let mock = MockCloudRecordService(saveResult: .success(()), readResult: .failure(.failed), deleteResult: .success(()))
        let state = await ReadICloudRecord(service: mock).execute(AppleServiceDomainState(), scope: .private, recordType: "Note", recordName: "one")
        #expect(state.iCloudRecordIdentifier == nil)
        #expect(state.iCloudRecordPayload == nil)
        #expect(state.lastError != nil)
    }
}
