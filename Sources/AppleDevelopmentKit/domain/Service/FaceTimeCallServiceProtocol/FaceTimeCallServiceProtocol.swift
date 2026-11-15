import Foundation

public protocol FaceTimeCallServiceProtocol: Sendable {
    func makeURL(destination: String, type: FaceTimeCallType) throws -> URL
}
