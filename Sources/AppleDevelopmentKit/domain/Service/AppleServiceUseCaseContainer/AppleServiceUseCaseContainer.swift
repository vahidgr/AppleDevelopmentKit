struct AppleServiceUseCaseContainer: Sendable {
    private let makeFaceTimeCallURL: MakeFaceTimeCallURL
    private let checkICloudAccount: CheckICloudAccount
    private let createCalendarEvent: CreateCalendarEvent
    private let createReminder: CreateReminder
    private let storeKeychainPassword: StoreKeychainPassword
    private let readKeychainPassword: ReadKeychainPassword
    private let deleteKeychainPassword: DeleteKeychainPassword
    private let clearKeychainPassword: ClearKeychainPassword
    private let listICloudDocuments: ListICloudDocuments
    private let copyFileToICloud: CopyFileToICloud
    private let downloadICloudFile: DownloadICloudFile
    private let exportIWorkDocumentToPDF: ExportIWorkDocumentToPDF
    private let makeMessageComposeURL: MakeMessageComposeURL
    private let openAppURL: OpenAppURL
    private let saveICloudRecord: SaveICloudRecord
    private let readICloudRecord: ReadICloudRecord
    private let deleteICloudRecord: DeleteICloudRecord

    init(
        makeFaceTimeCallURL: MakeFaceTimeCallURL = MakeFaceTimeCallURL(),
        checkICloudAccount: CheckICloudAccount = CheckICloudAccount(),
        createCalendarEvent: CreateCalendarEvent = CreateCalendarEvent(),
        createReminder: CreateReminder = CreateReminder(),
        storeKeychainPassword: StoreKeychainPassword = StoreKeychainPassword(),
        readKeychainPassword: ReadKeychainPassword = ReadKeychainPassword(),
        deleteKeychainPassword: DeleteKeychainPassword = DeleteKeychainPassword(),
        clearKeychainPassword: ClearKeychainPassword = ClearKeychainPassword(),
        listICloudDocuments: ListICloudDocuments = ListICloudDocuments(),
        copyFileToICloud: CopyFileToICloud = CopyFileToICloud(),
        downloadICloudFile: DownloadICloudFile = DownloadICloudFile(),
        exportIWorkDocumentToPDF: ExportIWorkDocumentToPDF = ExportIWorkDocumentToPDF(),
        makeMessageComposeURL: MakeMessageComposeURL = MakeMessageComposeURL(),
        openAppURL: OpenAppURL = OpenAppURL(),
        saveICloudRecord: SaveICloudRecord = SaveICloudRecord(),
        readICloudRecord: ReadICloudRecord = ReadICloudRecord(),
        deleteICloudRecord: DeleteICloudRecord = DeleteICloudRecord()
    ) {
        self.makeFaceTimeCallURL = makeFaceTimeCallURL
        self.checkICloudAccount = checkICloudAccount
        self.createCalendarEvent = createCalendarEvent
        self.createReminder = createReminder
        self.storeKeychainPassword = storeKeychainPassword
        self.readKeychainPassword = readKeychainPassword
        self.deleteKeychainPassword = deleteKeychainPassword
        self.clearKeychainPassword = clearKeychainPassword
        self.listICloudDocuments = listICloudDocuments
        self.copyFileToICloud = copyFileToICloud
        self.downloadICloudFile = downloadICloudFile
        self.exportIWorkDocumentToPDF = exportIWorkDocumentToPDF
        self.makeMessageComposeURL = makeMessageComposeURL
        self.openAppURL = openAppURL
        self.saveICloudRecord = saveICloudRecord
        self.readICloudRecord = readICloudRecord
        self.deleteICloudRecord = deleteICloudRecord
    }

    func send(_ state: AppleServiceDomainState, _ action: AppleServiceAction) async -> AppleServiceDomainState {
        switch action {
        case let .makeFaceTimeCallURL(destination, type):
            await makeFaceTimeCallURL.execute(state, destination: destination, type: type)
        case .checkICloudAccount:
            await checkICloudAccount.execute(state)
        case let .createCalendarEvent(title, startDate, endDate):
            await createCalendarEvent.execute(state, title: title, startDate: startDate, endDate: endDate)
        case let .createReminder(title, dueDate):
            await createReminder.execute(state, title: title, dueDate: dueDate)
        case let .storeKeychainPassword(service, account, password):
            await storeKeychainPassword.execute(state, serviceName: service, account: account, password: password)
        case let .readKeychainPassword(service, account):
            await readKeychainPassword.execute(state, serviceName: service, account: account)
        case let .deleteKeychainPassword(service, account):
            await deleteKeychainPassword.execute(state, serviceName: service, account: account)
        case .clearKeychainPassword:
            await clearKeychainPassword.execute(state)
        case let .listICloudDocuments(containerIdentifier):
            await listICloudDocuments.execute(state, containerIdentifier: containerIdentifier)
        case let .copyFileToICloud(sourceURL, fileName, containerIdentifier):
            await copyFileToICloud.execute(state, sourceURL: sourceURL, fileName: fileName, containerIdentifier: containerIdentifier)
        case let .downloadICloudFile(url):
            await downloadICloudFile.execute(state, url: url)
        case let .exportIWorkDocumentToPDF(documentURL, fileName, credentials):
            await exportIWorkDocumentToPDF.execute(state, documentURL: documentURL, fileName: fileName, credentials: credentials)
        case let .makeMessageComposeURL(recipient, body):
            await makeMessageComposeURL.execute(state, recipient: recipient, body: body)
        case let .openAppURL(url):
            await openAppURL.execute(state, url: url)
        case let .saveICloudRecord(scope, recordType, recordName, payload):
            await saveICloudRecord.execute(state, scope: scope, recordType: recordType, recordName: recordName, payload: payload)
        case let .readICloudRecord(scope, recordType, recordName):
            await readICloudRecord.execute(state, scope: scope, recordType: recordType, recordName: recordName)
        case let .deleteICloudRecord(scope, recordType, recordName):
            await deleteICloudRecord.execute(state, scope: scope, recordType: recordType, recordName: recordName)
        }
    }
}
