import Foundation
import Testing
@testable import AppleDevelopmentKit

@Suite struct DeleteICloudRecordTests {
    @Test func deletesRecordAndClearsState() async {
        let mock = MockCloudRecordService(saveResult: .success(()), readResult: .success(Data([2])), deleteResult: .success(()))
        let old = AppleServiceDomainState(iCloudRecordIdentifier: "one", iCloudRecordPayload: Data([2]))
        let state = await DeleteICloudRecord(service: mock).execute(old, scope: .private, recordType: "Note", recordName: "one")
        #expect(state.iCloudRecordIdentifier == nil)
        #expect(state.iCloudRecordPayload == nil)
        #expect(state.lastError == nil)
    }
    @Test func reportsDeleteFailure() async {
        let mock = MockCloudRecordService(saveResult: .success(()), readResult: .success(Data([2])), deleteResult: .failure(.failed))
        let state = await DeleteICloudRecord(service: mock).execute(AppleServiceDomainState(), scope: .private, recordType: "Note", recordName: "one")
        #expect(state.lastError != nil)
    }
}
