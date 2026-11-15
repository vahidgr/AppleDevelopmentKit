import Foundation
import Testing
@testable import AppleDevelopmentKit

@Suite struct ICloudDocumentServiceTests {
    @Test func rejectsPathTraversalFilename() async {
        await #expect(throws: ICloudDocumentService.Failure.invalidFileName) {
            try await ICloudDocumentService().copy(sourceURL: URL(fileURLWithPath: "/tmp/source"), fileName: "../escape", containerIdentifier: nil)
        }
    }
}
