# Apple service API coverage

AppleDevelopmentKit defines service protocols, provides reusable workflows, and re-exports Apple SDK modules. AppleServices implements its protocols as a separate data layer and provides a factory for wiring the adapters into workflows. The re-export makes documented framework symbols available to a consuming target; it does not change SDK availability, permissions, entitlements, extension requirements, sandboxing, or Apple service access policy.

Use `AppleServiceUseCaseCatalog` to search service names, framework names, and summaries. Its `access` field means:

- `useCase`: this package provides a reusable workflow.
- `nativeFramework`: use the re-exported Apple framework directly; the integration depends on the host app's data model or configuration.
- `hostAppIntegration`: Apple requires a host app or extension target, app lifecycle hook, or app-specific declaration.
- `unavailable`: Apple exposes no public API for the operation described.

| Service | Framework/API surface | Package workflow | Limits and host-app work |
| --- | --- | --- | --- |
| FaceTime | FaceTime URL schemes; GroupActivities | Validate a destination and create an audio/video URL | The host app opens the URL after user intent. No public call control or call history API. SharePlay activities and synchronization models are app-defined. |
| Messages / iMessage | Messages; `sms:` URL scheme | Build a URL that opens the system message composer with a recipient and optional draft body | The host app opens the URL through `.openAppURL`. Sending still requires user action. Interactive iMessage apps/stickers require an extension target. No general inbox/database access. |
| iCloud Drive files | Foundation ubiquitous containers, FileManager, NSFileCoordinator | List container documents, copy a local file into the container, and request download of an iCloud item | Configure iCloud entitlements and the app's ubiquitous container. Coordinate access and handle download/upload state. |
| Notes | No general public Notes database API | None | Apple does not expose general CRUD access to Notes. macOS Apple Events automation may be available but is app/version dependent and requires user automation consent. |
| Calendar | EventKit / EventKitUI | Create an event using write-only EventKit access | Request the applicable event access level, provide usage descriptions, and decide calendars and event semantics in the host app. |
| Reminders | EventKit / EventKitUI | Create a reminder using full Reminders access | Request reminder access and provide usage descriptions. The host app owns list selection and reminder semantics. |
| Keychain / Passwords | Security Keychain Services; AuthenticationServices | Store, read, update, and delete app-owned generic password items | Keychain access is for app-owned items and entitled access groups. Password AutoFill requires host-app configuration; credential provider features require an extension. The Passwords app database cannot be enumerated. |
| Pages | iWork Document Export API; macOS Apple Events | Export a Pages document to PDF | The REST API converts supported iWork documents to PDF; it is not general editing. It requires developer credentials and document upload. Package documents must be supplied as a ZIP archive. The source document is temporarily stored by Apple for conversion; disclose this and request user consent. Apple Events automation requires macOS, installed Pages, and user consent. |
| Numbers | iWork Document Export API; macOS Apple Events | Export a Numbers document to PDF | Same export and automation limits as Pages. No general public document-editing SDK. |
| Keynote | iWork Document Export API; macOS Apple Events | Export a Keynote document to PDF | Same export and automation limits as Pages. No general public document-editing SDK. |
| iCloud sync | CloudKit databases, CKSyncEngine, NSUbiquitousKeyValueStore, ubiquitous documents | Check account status and save, read, or delete app-owned CloudKit records in private, public, or shared databases | The record workflow stores an opaque `Data` payload in a `payload` field; keep payloads small and use `CKAsset` through the native API for large files. Configure the record type/schema, entitlements, container, conflict policy, and remote notifications. Advanced `CKSyncEngine` synchronization remains available through the native API. |
| App Intents | AppIntents, including AppIntent and OpenIntent | None | Intent types and entities describe the consuming app's own actions. Add declarations and runtime behavior to the host app target. |
| Delegates and app opening | UIKit/AppKit app and scene delegates, URL handlers, universal links | Open an HTTPS, custom-scheme, FaceTime, or SMS URL through the host application | Implement lifecycle and route handling in the app target. Universal links require Associated Domains and a valid apple-app-site-association file. |

## Import and use

```swift
import AppleDevelopmentKit
import AppleServices

let catalog = AppleServiceUseCaseCatalog()
let entries = catalog.search("EventKit")

let adapters = await AppleServicesDependencyFactory.makeAppleDevelopmentKitServices()
let state = await AppleServiceStateContainer(services: adapters)
await state.send(.checkICloudAccount)
await state.send(.saveICloudRecord(scope: .private, recordType: "Draft", recordName: "draft-1", payload: Data("...".utf8)))
await state.send(.openAppURL(URL(string: "myapp://draft/draft-1?instruction=edit")!))
```

For operations catalogued as native framework or host-app integration, import the re-exported module APIs through `AppleDevelopmentKit` and follow Apple's current documentation for the target SDK. This package does not generate app entitlements, privacy strings, extension targets, CloudKit schemas, or app delegate implementations.

## Official documentation

- [Messages](https://developer.apple.com/documentation/messages)
- [GroupActivities](https://developer.apple.com/documentation/groupactivities)
- [EventKit](https://developer.apple.com/documentation/eventkit)
- [Keychain Services](https://developer.apple.com/documentation/security/keychain_services)
- [Password AutoFill](https://developer.apple.com/documentation/security/password_autofill)
- [CloudKit](https://developer.apple.com/documentation/cloudkit)
- [CKSyncEngine](https://developer.apple.com/documentation/cloudkit/cksyncengine)
- [iCloud ubiquitous documents](https://developer.apple.com/documentation/foundation/filemanager)
- [App Intents](https://developer.apple.com/documentation/appintents)
- [Universal links](https://developer.apple.com/documentation/xcode/allowing-apps-and-websites-to-link-to-your-content)
- [iWork Document Export API](https://developer.apple.com/documentation/iworkdocumentexportingapi)
- [Notes API discussion with Apple DTS](https://developer.apple.com/forums/thread/813810)
