import XCTest
@testable import FlowDesignCore

final class FlowDesignDocumentTests: XCTestCase {
    func testNewUntitledDocumentStartsWithPhaseZeroSemanticModel() throws {
        let document = FlowDesignDocument.newUntitled()

        let viewTypes = document.flowViews.map(\.type)
        let appContainer = try XCTUnwrap(document.appContainer)

        XCTAssertEqual(document.schemaVersion, "0.1.0")
        XCTAssertEqual(document.lifecycleState, .draft)
        XCTAssertEqual(document.title, "Untitled Flow")
        XCTAssertEqual(viewTypes, [.appOverview, .happyPath, .componentLogic, .failurePath])
        XCTAssertEqual(document.canvases.map(\.name), ["App Overview", "Happy Path", "Component Logic", "Failure Path"])
        XCTAssertEqual(document.canvases.map(\.size), [.default, .default, .default, .default])
        XCTAssertEqual(appContainer.containerType, .appContainer)
        XCTAssertEqual(appContainer.viewIDs, document.flowViews.map(\.id))
        XCTAssertTrue(document.flowViews.allSatisfy { view in
            view.rootAppContainerID == document.appContainerID
                && view.objectIDs == [document.appContainerID]
        })
    }

    func testNewUntitledDocumentCreatesStableTextSectionOwnership() {
        let document = FlowDesignDocument.newUntitled()
        let appSections = document.textSections(
            ownerType: .container,
            ownerID: document.appContainerID
        )

        XCTAssertEqual(
            appSections.map(\.type),
            [.appSynopsis, .majorFeatures, .happyPathDescription, .logicDescription]
        )
        XCTAssertEqual(appSections.map(\.title), [
            "App Synopsis",
            "Major Features",
            "Happy Path Description",
            "Logic Description"
        ])

        for flowView in document.flowViews {
            let viewSections = document.textSections(ownerType: .view, ownerID: flowView.id)
            XCTAssertEqual(viewSections.map(\.type), [.viewDescription, .acceptanceCriteria])
        }
    }

    func testDocumentJSONRoundTripsSemanticFlowData() throws {
        var document = FlowDesignDocument.newUntitled()
        let viewID = try XCTUnwrap(document.flowViews.first?.id)
        let startID = UUID()
        let decisionID = UUID()
        let connectionID = UUID()
        let start = FlowElement(
            id: startID,
            elementType: .startEnd,
            label: "Start",
            layoutFrames: [
                ViewGeometry(
                    viewID: viewID,
                    frame: Geometry(x: 240, y: 260, width: 120, height: 64)
                )
            ],
            parentContainerID: document.appContainerID,
            viewIDs: [viewID]
        )
        let decision = FlowElement(
            id: decisionID,
            elementType: .decision,
            label: "Needs review?",
            layoutFrames: [
                ViewGeometry(
                    viewID: viewID,
                    frame: Geometry(x: 440, y: 248, width: 160, height: 88)
                )
            ],
            parentContainerID: document.appContainerID,
            viewIDs: [viewID]
        )
        let connection = FlowConnection(
            id: connectionID,
            source: FlowObjectReference(objectType: .element, objectID: startID),
            target: FlowObjectReference(objectType: .element, objectID: decisionID),
            label: "Next"
        )

        document.flowElements = [start, decision]
        document.flowConnections = [connection]
        document.flowViews[0].objectIDs.append(contentsOf: [startID, decisionID])
        document.flowViews[0].connectionIDs.append(connectionID)
        document.textSections[0].body = "A local-first flow document."

        let data = try document.encodedDocumentJSON()
        let json = try XCTUnwrap(String(data: data, encoding: .utf8))
        let decoded = try FlowDesignDocument.decodeDocumentJSON(from: data)

        XCTAssertTrue(json.contains(#""schemaVersion" : "0.1.0""#))
        XCTAssertTrue(json.contains(#""logic_description""#))
        XCTAssertEqual(decoded, document)
        XCTAssertEqual(decoded.flowElements.map(\.id), [startID, decisionID])
        XCTAssertEqual(decoded.flowConnections.first?.source.objectID, startID)
        XCTAssertEqual(decoded.flowConnections.first?.target.objectID, decisionID)
    }

    func testUnsupportedDocumentSchemaVersionFailsBeforeFullDecode() throws {
        let document = FlowDesignDocument.newUntitled()
        let data = try document.encodedDocumentJSON()
        let json = try XCTUnwrap(String(data: data, encoding: .utf8))
            .replacingOccurrences(of: #""schemaVersion" : "0.1.0""#, with: #""schemaVersion" : "9.9.9""#)

        XCTAssertThrowsError(
            try FlowDesignDocument.decodeDocumentJSON(from: Data(json.utf8))
        ) { error in
            XCTAssertEqual(error as? FlowDesignDocumentError, .unsupportedSchemaVersion("9.9.9"))
        }
    }
}
