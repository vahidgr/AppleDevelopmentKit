import Foundation
import Testing
@testable import AppleDevelopmentKit

@Suite struct AppleServiceUseCaseContainerTests {
    @Test func dispatchesEveryServiceWorkflowThroughTheActionContainer() async {
        let fileURL = URL(fileURLWithPath: "/tmp/cloud/document.pages")
        let files = MockICloudDocumentService(
            listResult: .success([fileURL]), copyResult: .success(fileURL), downloadResult: .success(())
        )
        let passwords = MockKeychainPasswordService(readResult: .success(Data([7])), writeResult: .success(()))
        let cloud = MockCloudRecordService(
            saveResult: .success(()), readResult: .success(Data([8])), deleteResult: .success(())
        )
        let container = AppleServiceUseCaseContainer(
            checkICloudAccount: CheckICloudAccount(iCloudAccountService: MockICloudAccountServiceForContainer()),
            createCalendarEvent: CreateCalendarEvent(service: MockCalendarEventService(result: .success("event"))),
            createReminder: CreateReminder(service: MockReminderService(result: .success("reminder"))),
            storeKeychainPassword: StoreKeychainPassword(service: passwords),
            readKeychainPassword: ReadKeychainPassword(service: passwords),
            deleteKeychainPassword: DeleteKeychainPassword(service: passwords),
            listICloudDocuments: ListICloudDocuments(service: files),
            copyFileToICloud: CopyFileToICloud(service: files),
            downloadICloudFile: DownloadICloudFile(service: files),
            exportIWorkDocumentToPDF: ExportIWorkDocumentToPDF(service: MockIWorkDocumentExportService(result: .success(fileURL))),
            makeMessageComposeURL: MakeMessageComposeURL(),
            openAppURL: OpenAppURL(service: MockAppURLService(result: .success(true))),
            saveICloudRecord: SaveICloudRecord(service: cloud),
            readICloudRecord: ReadICloudRecord(service: cloud),
            deleteICloudRecord: DeleteICloudRecord(service: cloud)
        )
        let start = Date.now
        let end = start.addingTimeInterval(60)
        var state = AppleServiceDomainState()

        state = await container.send(state, .makeFaceTimeCallURL(destination: "person@example.com", type: .video))
        #expect(state.faceTimeCallURL?.scheme == "facetime")
        state = await container.send(state, .checkICloudAccount)
        #expect(state.iCloudAccountStatus == "available")
        state = await container.send(state, .createCalendarEvent(title: "Meet", startDate: start, endDate: end))
        #expect(state.calendarEventIdentifier == "event")
        state = await container.send(state, .createReminder(title: "Task", dueDate: nil))
        #expect(state.reminderIdentifier == "reminder")
        state = await container.send(state, .storeKeychainPassword(service: "app", account: "user", password: Data([1])))
        state = await container.send(state, .readKeychainPassword(service: "app", account: "user"))
        #expect(state.keychainPassword == Data([7]))
        state = await container.send(state, .clearKeychainPassword)
        #expect(state.keychainPassword == nil)
        state = await container.send(state, .deleteKeychainPassword(service: "app", account: "user"))
        state = await container.send(state, .listICloudDocuments(containerIdentifier: nil))
        #expect(state.iCloudDocumentURLs == [fileURL])
        state = await container.send(state, .copyFileToICloud(sourceURL: fileURL, fileName: "copy.pages", containerIdentifier: nil))
        #expect(state.lastFileURL == fileURL)
        state = await container.send(state, .downloadICloudFile(fileURL))
        #expect(state.lastFileURL == fileURL)
        state = await container.send(state, .exportIWorkDocumentToPDF(documentURL: fileURL, fileName: "doc.pages", credentials: .init(teamIdentifier: "t", keyIdentifier: "k", privateKeyPEM: "pem")))
        #expect(state.exportedPDFURL == fileURL)
        state = await container.send(state, .makeMessageComposeURL(recipient: "+15550100", body: "hello"))
        #expect(state.messagesComposeURL?.scheme == "sms")
        let route = URL(string: "myapp://item/1")!
        state = await container.send(state, .openAppURL(route))
        #expect(state.lastOpenedURL == route)
        state = await container.send(state, .saveICloudRecord(scope: .private, recordType: "Item", recordName: "1", payload: Data([2])))
        #expect(state.iCloudRecordIdentifier == "1")
        state = await container.send(state, .readICloudRecord(scope: .private, recordType: "Item", recordName: "1"))
        #expect(state.iCloudRecordPayload == Data([8]))
        state = await container.send(state, .deleteICloudRecord(scope: .private, recordType: "Item", recordName: "1"))
        #expect(state.iCloudRecordIdentifier == nil)
        #expect(state.lastError == nil)
    }
}
