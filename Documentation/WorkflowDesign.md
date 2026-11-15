# Workflow design

## Module structure

The package is a Swift 6.4 feature package depending on AppleServices. Its target exposes the AppleServices umbrella import, then provides a small stateful use-case surface:

```text
Sources/AppleServiceUseCases/
├── AppleServiceUseCases.swift          # Re-exports AppleServices
└── domain/
    ├── DomainAction/                   # Public input actions
    ├── DomainModel/                    # Public input/output values
    ├── Service/                        # Internal platform adapters/orchestration
    ├── State/                          # Public observable state container
    └── UseCase/                        # Internal action workflows
```

Concrete types live in a role directory named after the type. Tests mirror the production role path.

## Concurrency and state

`AppleServiceActor` isolates `AppleServiceStateContainer`. Clients create the container and send `AppleServiceAction` values asynchronously. Use cases receive the existing immutable domain state and an action payload, produce a new state, and log failures through `ObservabilityService` in debug builds.

The container is app-owned state, not a process-global singleton. Create one per independent workflow/session owner and observe its `state` using Swift Observation.

## Current workflows

### FaceTime URL creation

`makeFaceTimeCallURL` trims surrounding whitespace, rejects empty values, and rejects destinations containing characters outside letters, digits, and the supported phone/email punctuation set. It returns a URL; it does not initiate a call. The containing app should open the URL only in response to a user action and should handle platform-specific open failures.

### iCloud account status

`checkICloudAccount` calls CloudKit’s account-status API and stores the status as a stable string. This is a connectivity/account check, not a sync operation. CloudKit sync must be designed around the consuming app’s record types and conflict policy. Apple’s `CKSyncEngine` remains available through the native re-export for that implementation.

## Extension points

Add a new workflow by defining a public `AppleServiceAction` case and domain payload, a domain state output if needed, a Service adapter for native Apple API calls, and an internal UseCase that maps the action and existing state to a new state. Add Swift Testing coverage for success and error paths. Keep host-app setup (entitlements, Info.plist keys, extension targets, associated domains, CloudKit schema) in the consuming app and document it alongside the relevant workflow.

## Intentional boundaries

This library cannot expose APIs Apple does not make public to third-party developers. It also cannot provide complete generic app actions where the behavior depends on the consuming app’s model, UI, record schema, or credentials. The native framework re-export ensures callers retain access to the full documented SDK surface while the use-case layer grows around stable, reusable workflows.
