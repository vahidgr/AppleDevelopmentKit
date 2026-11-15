import Foundation

public protocol CalendarEventServiceProtocol: Sendable {
    func create(title: String, startDate: Date, endDate: Date) async throws -> String
}
