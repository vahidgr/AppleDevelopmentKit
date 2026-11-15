import Foundation

public protocol ReminderServiceProtocol: Sendable {
    func create(title: String, dueDate: Date?) async throws -> String
}
