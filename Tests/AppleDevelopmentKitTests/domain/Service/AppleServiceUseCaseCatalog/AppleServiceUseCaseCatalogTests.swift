import Testing
@testable import AppleDevelopmentKit

@Suite struct AppleServiceUseCaseCatalogTests {
    @Test func listsAllRequestedServicesAndIntegrationSurfaces() {
        let entries = AppleServiceUseCaseCatalog().all
        #expect(entries.count == 13)
        #expect(Set(entries.map(\.id)) == Set([
            "facetime", "messages", "icloud-files", "notes", "calendar", "reminders",
            "keychain", "pages", "numbers", "keynote", "app-intents", "app-lifecycle", "icloud-sync"
        ]))
        #expect(entries.first(where: { $0.id == "notes" })?.access == .unavailable)
        #expect(entries.first(where: { $0.id == "facetime" })?.access == .useCase)
    }

    @Test func searchesServiceNameFrameworkAndSummary() {
        let catalog = AppleServiceUseCaseCatalog()
        #expect(catalog.search("  ").count == 13)
        #expect(catalog.search("reminders").map(\.id) == ["reminders"])
        #expect(catalog.search("EventKit").map(\.id) == ["calendar", "reminders"])
        #expect(Set(catalog.search("database").map(\.id)) == Set(["messages", "notes"]))
        #expect(catalog.search("not-a-service").isEmpty)
    }
}
