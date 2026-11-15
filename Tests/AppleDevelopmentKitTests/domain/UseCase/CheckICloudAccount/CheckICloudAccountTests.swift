import Testing
@testable import AppleDevelopmentKit

struct CheckICloudAccountTests {
    @Test func storesAvailableAccountStatus() async {
        let useCase = CheckICloudAccount(iCloudAccountService: MockICloudAccountService(result: .success("available")))
        let state = await useCase.execute(AppleServiceDomainState())

        #expect(state.iCloudAccountStatus == "available")
        #expect(state.lastError == nil)
    }

    @Test func storesFailureForUnavailableAccountCheck() async {
        let useCase = CheckICloudAccount(iCloudAccountService: MockICloudAccountService(result: .failure(MockFailure.failed)))
        let state = await useCase.execute(AppleServiceDomainState())

        #expect(state.iCloudAccountStatus == nil)
        #expect(state.lastError != nil)
    }
}

private struct MockICloudAccountService: ICloudAccountServiceProtocol {
    let result: Result<String, MockFailure>

    func accountStatus() async throws -> String {
        try result.get()
    }
}

private enum MockFailure: Error {
    case failed
}
