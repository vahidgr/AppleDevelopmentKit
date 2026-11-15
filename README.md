# AppleDevelopmentKit

AppleDevelopmentKit is a Swift Package Manager library that provides reusable workflows over public Apple APIs and re-exports the native API umbrella from [AppleServices](https://github.com/vahidgr/AppleServices).

## Requirements

- Swift 6.4 or later
- iOS/iPadOS 17 or later
- macOS 14 or later
- Xcode and the Apple SDKs for the platforms you build

The iOS SDK target covers iPhone and iPad. Native API availability may impose a higher minimum OS version for particular symbols.

## Add the package

In Xcode, choose **File → Add Package Dependencies** and enter this repository’s URL. In a Swift package manifest:

```swift
dependencies: [
    .package(url: "https://github.com/vahidgr/AppleDevelopmentKit.git", from: "2.0.0")
]
```

Add the `AppleDevelopmentKit` product to your target. Importing it also makes the public modules re-exported by `AppleServices` available:

```swift
import AppleDevelopmentKit
```

## Use-case API

The package’s public workflow is an action/state interface:

```swift
import AppleDevelopmentKit

let services = await AppleServiceStateContainer()

await services.send(.makeFaceTimeCallURL(
    destination: "person@example.com",
    type: .video
))

if let callURL = await services.state.faceTimeCallURL {
    // Open the URL through UIApplication or NSWorkspace after a user action.
}

await services.send(.checkICloudAccount)
let accountStatus = await services.state.iCloudAccountStatus
```

### Public types and actions

| Type/API | Contract |
| --- | --- |
| `AppleServiceActor` | Global actor that serializes access to the workflow state container. |
| `AppleServiceStateContainer` | Observable state holder. `send(_:)` asynchronously handles an action; `state` is read-only to clients. |
| `AppleServiceAction.makeFaceTimeCallURL(destination:type:)` | Validates a phone-number/email-like destination and stores a `facetime:` or `facetime-audio:` URL. It creates the URL only; the host app performs the system open after the user requests a call. |
| `AppleServiceAction.makeMessageComposeURL(recipient:body:)` | Creates an `sms:` URL with an optional draft. The system opens the composer; the user sends. |
| `AppleServiceAction.openAppURL(_:)` | Opens a supported URL through UIKit or AppKit. Custom schemes support app deep links with route/instruction data. |
| `AppleServiceAction.checkICloudAccount` | Queries `CKContainer.default().accountStatus()` and stores a status string. The status can be `available`, `noAccount`, `restricted`, `temporarilyUnavailable`, `couldNotDetermine`, or `unknown`. |
| `AppleServiceAction.createCalendarEvent(title:startDate:endDate:)` | Creates an event in the default writable calendar after requesting write-only access. |
| `AppleServiceAction.createReminder(title:dueDate:)` | Creates a reminder in the default writable Reminders list after requesting full access. |
| `AppleServiceAction.storeKeychainPassword(service:account:password:)`, `.readKeychainPassword(service:account:)`, `.deleteKeychainPassword(service:account:)`, `.clearKeychainPassword` | Manage a generic password item in the app’s own Keychain access group. Clear observable plaintext after reading. |
| `AppleServiceAction.listICloudDocuments(containerIdentifier:)`, `.copyFileToICloud(sourceURL:fileName:containerIdentifier:)`, `.downloadICloudFile(_:)` | List, copy into, and request download from the configured ubiquitous Documents directory. |
| `AppleServiceAction.saveICloudRecord(scope:recordType:recordName:payload:)`, `.readICloudRecord(scope:recordType:recordName:)`, `.deleteICloudRecord(scope:recordType:recordName:)` | Store app-owned opaque `Data` in a CloudKit record’s `payload` field in the selected database. |
| `AppleServiceAction.exportIWorkDocumentToPDF(documentURL:fileName:credentials:)` | Upload a Pages, Numbers, or Keynote file to Apple’s iWork export API and write the PDF result to a temporary file. |
| `FaceTimeCallType` | Selects `.audio` or `.video`. |
| `ICloudDatabaseScope` | Selects the CloudKit private, public, or shared database. |
| `IWorkExportCredentials` | Supplies the iWork API team ID, key ID, and PEM private key at runtime. Treat the value as a secret. |
| `AppleServiceDomainState` | Read-only public snapshot of workflow results and `lastError`. It may hold Keychain password bytes after a read until cleared. |

On a failed action, the relevant result is cleared, `lastError` is set, and the error is logged to standard error in `DEBUG` builds. A successful action clears `lastError`.

## Service coverage catalog

`AppleServiceUseCaseCatalog` gives a searchable inventory of the requested Apple services and whether each is available as a package workflow, through a native framework, through host-app integration, or not available as a public API:

```swift
let capabilities = AppleServiceUseCaseCatalog().search("EventKit")
```

The catalog covers FaceTime/SharePlay, Messages, iCloud Drive, Notes, Calendar, Reminders, Keychain/Password AutoFill, Pages, Numbers, Keynote, App Intents, app lifecycle/delegates, and iCloud sync. `AppleServiceCapability` identifies the access class, related framework modules, and relevant API boundary. The full native API symbols remain available through the `AppleServices` re-export.

Implemented workflows now include FaceTime and SMS composer URL creation, CloudKit account status, Calendar event creation, Reminders creation, app-owned Keychain password store/read/delete, iCloud Drive document list/copy/download, and Pages/Numbers/Keynote PDF export through Apple's authenticated iWork API. Read Keychain data is held in observable state until `.clearKeychainPassword` or a delete action; copy it promptly and clear it when finished.

```swift
await services.send(.createCalendarEvent(title: "Review", startDate: start, endDate: end))
await services.send(.createReminder(title: "Send report", dueDate: dueDate))
await services.send(.storeKeychainPassword(service: "com.example", account: "user", password: Data(password.utf8)))
await services.send(.readKeychainPassword(service: "com.example", account: "user"))
await services.send(.clearKeychainPassword)
await services.send(.listICloudDocuments(containerIdentifier: nil))
```

Calendar event creation requires `NSCalendarsWriteOnlyAccessUsageDescription` (and the matching macOS Calendar entitlement where applicable); reminder creation requires `NSRemindersFullAccessUsageDescription` and any required macOS entitlement. iCloud Drive needs the correct ubiquity container entitlement. iWork export requires a Services ID and ES256 developer key. The package never includes those credentials. See [Service Coverage](Documentation/ServiceCoverage.md) for setup details and limits.

## Native API access and host-app responsibilities

The package re-exports all modules from `AppleServices`; import `AppleDevelopmentKit` when using either its workflows or the underlying native frameworks. The host app remains responsible for:

- Messages app extensions and credential-provider extensions, which require extension targets and entitlements.
- App Intents and app/scene delegates, which must be connected to the host application’s actions, entities, scene setup, and associated domains. `openAppURL` only opens the provided URL; it does not install a route handler.
- CloudKit record schema, entitlements, conflict resolution, user identity policy, and `CKSyncEngine` lifecycle for full synchronization.
- Calendar/Reminders privacy descriptions and user-facing authorization UX.
- iWork Services ID credentials and file consent. The API converts supported files to PDF; it does not edit documents.
- Notes database access, for which Apple provides no public API.

Use the native re-export for those operations. See [Workflow Design](Documentation/WorkflowDesign.md), [service coverage](Documentation/ServiceCoverage.md), and the [AppleServices framework coverage](../AppleServices/Documentation/FrameworkCoverage.md).

## Build and test

```sh
swift test
```

The test target uses Swift Testing. The package can be cross-built for the iOS Simulator SDK and macOS SDK; simulator execution requires an installed and working CoreSimulator runtime.
