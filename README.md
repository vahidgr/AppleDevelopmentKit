# AppleServiceUseCases

AppleServiceUseCases is a Swift Package Manager library that provides reusable workflows over public Apple APIs and re-exports the native API umbrella from [AppleServices](https://github.com/vahidgr/AppleServices).

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
    .package(url: "https://github.com/vahidgr/AppleServiceUseCases.git", from: "1.0.0")
]
```

Add the `AppleServiceUseCases` product to your target. Importing it also makes the public modules re-exported by `AppleServices` available:

```swift
import AppleServiceUseCases
```

## Use-case API

The package’s public workflow is an action/state interface:

```swift
import AppleServiceUseCases

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
| `AppleServiceAction.checkICloudAccount` | Queries `CKContainer.default().accountStatus()` and stores a status string. The status can be `available`, `noAccount`, `restricted`, `temporarilyUnavailable`, `couldNotDetermine`, or `unknown`. |
| `FaceTimeCallType` | Selects `.audio` or `.video`. |
| `AppleServiceDomainState` | Read-only public snapshot exposing `faceTimeCallURL`, `iCloudAccountStatus`, and `lastError`. |

On a failed action, the relevant result is cleared, `lastError` is set, and the error is logged to standard error in `DEBUG` builds. A successful action clears `lastError`.

## Native API access and host-app responsibilities

The package re-exports all modules from `AppleServices`; import `AppleServiceUseCases` when using either its workflows or the underlying native frameworks. The current use-case layer intentionally does not invent app-specific behavior for:

- Messages app extensions and credential-provider extensions, which require extension targets and entitlements.
- App Intents, app/scene delegates, and URL routing, which must be connected to the host application’s actions, entities, scene setup, and associated domains.
- CloudKit record synchronization, which requires the app’s record schema, pending-change policy, delegate, saved `CKSyncEngine` state, container entitlement, and remote-notification configuration.
- Calendar/Reminders access, which requires app-specific authorization UX and data choices.
- iWork export, which requires developer credentials and document handling; the service converts supported files to PDF rather than editing them.
- Notes database access, for which Apple provides no public API.

Use the native re-export for those operations. See [Workflow Design](Documentation/WorkflowDesign.md) and the [AppleServices framework coverage](../AppleServices/Documentation/FrameworkCoverage.md).

## Build and test

```sh
swift test
```

The test target uses Swift Testing. The package can be cross-built for the iOS Simulator SDK and macOS SDK; simulator execution requires an installed and working CoreSimulator runtime.
