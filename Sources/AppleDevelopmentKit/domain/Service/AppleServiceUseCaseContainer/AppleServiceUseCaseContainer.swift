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

    init(services: AppleDevelopmentKitServices) {
        let log = services.observability
        makeFaceTimeCallURL = MakeFaceTimeCallURL(faceTimeCallService: services.faceTimeCall, observabilityService: log)
        checkICloudAccount = CheckICloudAccount(iCloudAccountService: services.iCloudAccount, observabilityService: log)
        createCalendarEvent = CreateCalendarEvent(service: services.calendarEvent, observabilityService: log)
        createReminder = CreateReminder(service: services.reminder, observabilityService: log)
        storeKeychainPassword = StoreKeychainPassword(service: services.keychainPassword, observabilityService: log)
        readKeychainPassword = ReadKeychainPassword(service: services.keychainPassword, observabilityService: log)
        deleteKeychainPassword = DeleteKeychainPassword(service: services.keychainPassword, observabilityService: log)
        clearKeychainPassword = ClearKeychainPassword()
        listICloudDocuments = ListICloudDocuments(service: services.iCloudDocument, observabilityService: log)
        copyFileToICloud = CopyFileToICloud(service: services.iCloudDocument, observabilityService: log)
        downloadICloudFile = DownloadICloudFile(service: services.iCloudDocument, observabilityService: log)
        exportIWorkDocumentToPDF = ExportIWorkDocumentToPDF(service: services.iWorkDocumentExport, observabilityService: log)
        makeMessageComposeURL = MakeMessageComposeURL(service: services.messageCompose, observabilityService: log)
        openAppURL = OpenAppURL(service: services.appURL, observabilityService: log)
        saveICloudRecord = SaveICloudRecord(service: services.cloudRecord, observabilityService: log)
        readICloudRecord = ReadICloudRecord(service: services.cloudRecord, observabilityService: log)
        deleteICloudRecord = DeleteICloudRecord(service: services.cloudRecord, observabilityService: log)
    }

    func send(_ state: AppleServiceDomainState, _ action: AppleServiceAction) async -> AppleServiceDomainState {
        switch action {
        case let .makeFaceTimeCallURL(destination, type): await makeFaceTimeCallURL.execute(state, destination: destination, type: type)
        case .checkICloudAccount: await checkICloudAccount.execute(state)
        case let .createCalendarEvent(title, startDate, endDate): await createCalendarEvent.execute(state, title: title, startDate: startDate, endDate: endDate)
        case let .createReminder(title, dueDate): await createReminder.execute(state, title: title, dueDate: dueDate)
        case let .storeKeychainPassword(service, account, password): await storeKeychainPassword.execute(state, serviceName: service, account: account, password: password)
        case let .readKeychainPassword(service, account): await readKeychainPassword.execute(state, serviceName: service, account: account)
        case let .deleteKeychainPassword(service, account): await deleteKeychainPassword.execute(state, serviceName: service, account: account)
        case .clearKeychainPassword: await clearKeychainPassword.execute(state)
        case let .listICloudDocuments(containerIdentifier): await listICloudDocuments.execute(state, containerIdentifier: containerIdentifier)
        case let .copyFileToICloud(sourceURL, fileName, containerIdentifier): await copyFileToICloud.execute(state, sourceURL: sourceURL, fileName: fileName, containerIdentifier: containerIdentifier)
        case let .downloadICloudFile(url): await downloadICloudFile.execute(state, url: url)
        case let .exportIWorkDocumentToPDF(documentURL, fileName, credentials): await exportIWorkDocumentToPDF.execute(state, documentURL: documentURL, fileName: fileName, credentials: credentials)
        case let .makeMessageComposeURL(recipient, body): await makeMessageComposeURL.execute(state, recipient: recipient, body: body)
        case let .openAppURL(url): await openAppURL.execute(state, url: url)
        case let .saveICloudRecord(scope, recordType, recordName, payload): await saveICloudRecord.execute(state, scope: scope, recordType: recordType, recordName: recordName, payload: payload)
        case let .readICloudRecord(scope, recordType, recordName): await readICloudRecord.execute(state, scope: scope, recordType: recordType, recordName: recordName)
        case let .deleteICloudRecord(scope, recordType, recordName): await deleteICloudRecord.execute(state, scope: scope, recordType: recordType, recordName: recordName)
        }
    }
}
