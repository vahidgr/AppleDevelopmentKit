/// Searchable inventory of Apple service workflows and native framework access.
public struct AppleServiceUseCaseCatalog: Sendable {
    public init() {}

    public var all: [AppleServiceCapability] {
        [
            .init(id: "facetime", name: "FaceTime and SharePlay", access: .useCase,
                  frameworks: ["GroupActivities"], summary: "Create FaceTime audio/video links. SharePlay activities are app-defined; call control and call history are unavailable."),
            .init(id: "messages", name: "Messages and iMessage", access: .useCase,
                  frameworks: ["Messages"], summary: "Build an SMS composer URL with optional draft text; interactive iMessage extensions remain host-app integrations. General inbox/database access is unavailable."),
            .init(id: "icloud-files", name: "iCloud Drive files", access: .useCase,
                  frameworks: ["Foundation", "CloudKit"], summary: "Use ubiquitous containers, file coordination, and CloudKit for the consuming app's own data and entitlements."),
            .init(id: "notes", name: "Notes", access: .unavailable,
                  frameworks: [], summary: "Apple provides no public general-purpose API for reading or editing the Notes database."),
            .init(id: "calendar", name: "Calendar", access: .useCase,
                  frameworks: ["EventKit", "EventKitUI"], summary: "Read and create events through EventKit after the app obtains the required authorization."),
            .init(id: "reminders", name: "Reminders", access: .useCase,
                  frameworks: ["EventKit", "EventKitUI"], summary: "Read and create reminders through EventKit after the app obtains the required authorization."),
            .init(id: "keychain", name: "Keychain and Password AutoFill", access: .useCase,
                  frameworks: ["Security", "AuthenticationServices"], summary: "Manage the calling app's Keychain items or implement credential-provider extensions. Passwords app contents cannot be enumerated."),
            .init(id: "pages", name: "Pages", access: .useCase,
                  frameworks: ["Foundation", "AppleScriptObjC"], summary: "Export supported documents to PDF through the authenticated iWork Document Export API; general editing is unavailable."),
            .init(id: "numbers", name: "Numbers", access: .useCase,
                  frameworks: ["Foundation", "AppleScriptObjC"], summary: "Export supported documents to PDF through the authenticated iWork Document Export API; general editing is unavailable."),
            .init(id: "keynote", name: "Keynote", access: .useCase,
                  frameworks: ["Foundation", "AppleScriptObjC"], summary: "Export supported documents to PDF through the authenticated iWork Document Export API; general editing is unavailable."),
            .init(id: "app-intents", name: "App Intents", access: .hostAppIntegration,
                  frameworks: ["AppIntents"], summary: "Expose the consuming app's own actions and entities to system experiences."),
            .init(id: "app-lifecycle", name: "Delegates and app opening", access: .hostAppIntegration,
                  frameworks: ["UIKit", "AppKit"], summary: "App and scene delegates, URL routes, universal links, and launch options must be wired in the host app target."),
            .init(id: "icloud-sync", name: "iCloud sync", access: .useCase,
                  frameworks: ["CloudKit", "Foundation"], summary: "Check the iCloud account and save, read, and delete app-owned CloudKit records; schema, entitlements, and conflict policy remain app-specific.")
        ]
    }

    public func search(_ query: String) -> [AppleServiceCapability] {
        let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { return all }
        return all.filter {
            $0.name.localizedCaseInsensitiveContains(term)
                || $0.id.localizedCaseInsensitiveContains(term)
                || $0.frameworks.contains { $0.localizedCaseInsensitiveContains(term) }
                || $0.summary.localizedCaseInsensitiveContains(term)
        }
    }
}
