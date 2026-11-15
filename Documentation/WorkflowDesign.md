# Workflow design

## Module structure

The package is a Swift 6.4 domain package with public service protocols and a stateful use-case surface. It does not depend on AppleServices. The application composition root supplies protocol implementations from the data package:

```text
Sources/AppleDevelopmentKit/
├── AppleDevelopmentKit.swift          # Re-exports AppleServices
└── domain/
    ├── DomainAction/                   # Public input actions
    ├── DomainModel/                    # Public input/output values
    ├── Service/                        # Public service interfaces and orchestration
    ├── State/                          # Public observable state container
    └── UseCase/                        # Internal action workflows
```

Concrete types live in a role directory named after the type. Tests mirror the production role path.

## Concurrency and state

`AppleServiceActor` isolates `AppleServiceStateContainer`. Clients create the container and send `AppleServiceAction` values asynchronously. Use cases receive the existing immutable domain state, an action payload, and injected service interfaces, produce a new state, and log failures through `ObservabilityServiceProtocol`.

The container is app-owned state, not a process-global singleton. Create one per independent workflow/session owner and observe its `state` using Swift Observation.

## Current workflows

### FaceTime URL creation

`makeFaceTimeCallURL` trims surrounding whitespace, rejects empty values, and rejects destinations containing characters outside letters, digits, and the supported phone/email punctuation set. It returns a URL; it does not initiate a call. The containing app should open the URL only in response to a user action and should handle platform-specific open failures.

### iCloud and files

`checkICloudAccount` calls CloudKit’s account-status API and stores the status as a stable string. iCloud document workflows list a configured ubiquitous Documents directory, copy a local file into it, and request an iCloud download. The consuming target must supply the iCloud container entitlement. This does not implement CloudKit record synchronization; that requires the consuming app’s schema, conflict policy, delegate, and persisted engine state.

### Calendar and Reminders

`createCalendarEvent` requests write-only event permission and creates an event in EventKit’s default writable calendar. `createReminder` requests full Reminders access and creates a reminder in the default writable list. The host target must provide the appropriate privacy usage descriptions and any macOS sandbox entitlements. The app should only send these actions in response to the user asking to create the item.

### Keychain passwords

Store, read, and delete actions operate on generic password items in the calling app’s Keychain access group. Read results enter the observable domain state until the app sends `clearKeychainPassword`; callers should minimize how long that state is observed. These workflows do not access Passwords app data or implement AutoFill credential-provider extensions.

### Messages, app opening, and iWork documents

`openAppURL` asks UIKit or AppKit to open an HTTPS/universal link, a custom deep link, or a supported system URL. The containing app still implements the route handler and universal-link association. The host should send this action only in response to a user action.

`makeMessageComposeURL` creates an `sms:` URL containing a recipient and optional draft body. The host app opens it; the user reviews and sends the message. It does not read Messages or send in the background. `exportIWorkDocumentToPDF` sends a Pages, Numbers, or Keynote file to Apple’s authenticated export endpoint and writes the resulting PDF into a temporary file. The host app provides ES256 credentials and must disclose that the source document is temporarily uploaded to Apple. This endpoint exports PDF only; it does not edit documents.

## Extension points

Add a new workflow by defining a public `AppleServiceAction` case and domain payload, a domain state output if needed, a Service adapter for native Apple API calls, and an internal UseCase that maps the action and existing state to a new state. Add Swift Testing coverage for success and error paths. Keep host-app setup (entitlements, Info.plist keys, extension targets, associated domains, CloudKit schema) in the consuming app and document it alongside the relevant workflow.

## Intentional boundaries

This library cannot expose APIs Apple does not make public to third-party developers. It also cannot provide complete generic app actions where the behavior depends on the consuming app’s model, UI, record schema, or credentials. The separate AppleServices package re-exports native framework modules and implements these stable interfaces; the use-case layer can evolve independently.

## Full service API coverage

`AppleServiceUseCaseCatalog` is the searchable service inventory. It records the workflows currently implemented in this package and directs callers to native frameworks re-exported by AppleServices for APIs that require host-owned configuration. See [Service Coverage](ServiceCoverage.md) for the API and limitation matrix for FaceTime, Messages, iCloud Drive, Notes, Calendar, Reminders, Keychain/Passwords, Pages, Numbers, Keynote, App Intents, app lifecycle/delegates, and iCloud sync.

The catalog is metadata, not an execution facade. See the service-specific workflow sections and [Service Coverage](ServiceCoverage.md) for implemented operations and APIs that remain host-app responsibilities. Notes database CRUD and general Messages database access are not public third-party APIs.
