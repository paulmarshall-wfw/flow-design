import XCTest
@testable import FlowDesignCore

final class FlowDesignDocumentTests: XCTestCase {
    func testNewUntitledDocumentStartsWithOneDefaultCanvas() {
        let document = FlowDesignDocument.newUntitled()

        XCTAssertEqual(document.title, "Untitled Flow")
        XCTAssertEqual(document.canvases.count, 1)
        XCTAssertEqual(document.canvases.first?.name, "Canvas 1")
        XCTAssertEqual(document.canvases.first?.size, .default)
    }
}
