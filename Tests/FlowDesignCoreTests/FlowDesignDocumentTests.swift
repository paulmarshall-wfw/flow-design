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

    func testDocumentTitleEditUpdatesRevisionAndTimestamp() {
        var document = FlowDesignDocument.newUntitled()
        let originalUpdatedAt = document.updatedAt
        let editDate = Date(timeIntervalSince1970: 1_819_584_000)

        XCTAssertTrue(document.updateTitle("Checkout Flow", updatedAt: editDate))
        XCTAssertTrue(document.updateTitle("Checkout Flow", updatedAt: editDate.addingTimeInterval(60)))

        XCTAssertEqual(document.title, "Checkout Flow")
        XCTAssertEqual(document.revision, 1)
        XCTAssertEqual(document.updatedAt, editDate)
        XCTAssertNotEqual(document.updatedAt, originalUpdatedAt)
    }

    func testTextSectionBodyEditUpdatesRevisionAndTimestamps() throws {
        var document = FlowDesignDocument.newUntitled()
        let sectionID = try XCTUnwrap(document.textSections.first?.id)
        let originalUpdatedAt = document.updatedAt
        let editDate = Date(timeIntervalSince1970: 1_819_584_000)

        XCTAssertTrue(document.updateTextSectionBody(
            sectionID: sectionID,
            body: "This app documents checkout behavior.",
            updatedAt: editDate
        ))
        XCTAssertTrue(document.updateTextSectionBody(
            sectionID: sectionID,
            body: "This app documents checkout behavior.",
            updatedAt: editDate.addingTimeInterval(60)
        ))

        let section = try XCTUnwrap(document.textSections.first { $0.id == sectionID })
        XCTAssertEqual(section.body, "This app documents checkout behavior.")
        XCTAssertEqual(section.updatedAt, editDate)
        XCTAssertEqual(document.revision, 1)
        XCTAssertEqual(document.updatedAt, editDate)
        XCTAssertNotEqual(document.updatedAt, originalUpdatedAt)
    }

    func testTextSectionBodyEditWithUnknownSectionDoesNotMutateDocument() {
        var document = FlowDesignDocument.newUntitled()
        let originalDocument = document

        XCTAssertFalse(document.updateTextSectionBody(
            sectionID: UUID(),
            body: "Ignored text",
            updatedAt: Date(timeIntervalSince1970: 1_819_584_000)
        ))
        XCTAssertEqual(document, originalDocument)
    }

    func testAllDefaultAppTextSectionsCanBeEditedAndPersisted() throws {
        var document = FlowDesignDocument.newUntitled()
        let appSections = document.appTextSections
        let baseEditDate = Date(timeIntervalSince1970: 1_819_584_000)

        for (offset, section) in appSections.enumerated() {
            XCTAssertTrue(document.updateTextSectionBody(
                sectionID: section.id,
                body: "Edited \(section.title)",
                updatedAt: baseEditDate.addingTimeInterval(TimeInterval(offset))
            ))
        }

        let packageURL = temporaryPackageURL()
        try FlowDesignDocumentPackageStore.save(document, to: packageURL)

        let loaded = try FlowDesignDocumentPackageStore.load(from: packageURL)
        XCTAssertEqual(document.revision, appSections.count)
        XCTAssertEqual(loaded.appTextSections.map(\.id), appSections.map(\.id))
        XCTAssertEqual(
            loaded.appTextSections.map(\.body),
            appSections.map { "Edited \($0.title)" }
        )
    }

    func testAllDefaultViewTextSectionsCanBeEditedAndPersisted() throws {
        var document = FlowDesignDocument.newUntitled()
        let view = try XCTUnwrap(document.flowViews.first)
        let viewSections = document.viewTextSections(viewID: view.id)
        let baseEditDate = Date(timeIntervalSince1970: 1_819_584_000)

        XCTAssertEqual(viewSections.map(\.type), [.viewDescription, .acceptanceCriteria])

        for (offset, section) in viewSections.enumerated() {
            XCTAssertTrue(document.updateTextSectionBody(
                sectionID: section.id,
                body: "Edited \(view.name) \(section.title)",
                updatedAt: baseEditDate.addingTimeInterval(TimeInterval(offset))
            ))
        }

        let packageURL = temporaryPackageURL()
        try FlowDesignDocumentPackageStore.save(document, to: packageURL)

        let loaded = try FlowDesignDocumentPackageStore.load(from: packageURL)
        let loadedViewSections = loaded.viewTextSections(viewID: view.id)
        XCTAssertEqual(document.revision, viewSections.count)
        XCTAssertEqual(loaded.flowView(id: view.id)?.name, view.name)
        XCTAssertEqual(loadedViewSections.map(\.id), viewSections.map(\.id))
        XCTAssertEqual(
            loadedViewSections.map(\.body),
            viewSections.map { "Edited \(view.name) \($0.title)" }
        )
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

    func testDocumentPackageSaveAndLoadRoundTripsDocumentJSON() throws {
        var document = FlowDesignDocument.newUntitled()
        document.updateTitle("Checkout Flow", updatedAt: Date(timeIntervalSince1970: 1_819_584_000))
        document.summary = "A local package document."
        let sectionID = try XCTUnwrap(document.textSections.first?.id)
        XCTAssertTrue(document.updateTextSectionBody(
            sectionID: sectionID,
            body: "Open the app, edit a flow, and save the package.",
            updatedAt: Date(timeIntervalSince1970: 1_819_584_120)
        ))

        let packageURL = temporaryPackageURL()
        try FlowDesignDocumentPackageStore.save(document, to: packageURL)

        let loaded = try FlowDesignDocumentPackageStore.load(from: packageURL)
        let documentJSONURL = packageURL.appendingPathComponent(FlowDesignDocument.documentJSONFileName)

        XCTAssertTrue(FileManager.default.fileExists(atPath: documentJSONURL.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: packageURL.appendingPathComponent("paperkit").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: packageURL.appendingPathComponent("previews").path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: packageURL.appendingPathComponent("provenance").path))
        XCTAssertEqual(loaded, document)
        XCTAssertEqual(loaded.title, "Checkout Flow")
        XCTAssertEqual(loaded.revision, 2)
        XCTAssertEqual(loaded.id, document.id)
        XCTAssertEqual(loaded.appContainerID, document.appContainerID)
        XCTAssertEqual(loaded.flowViews.map(\.id), document.flowViews.map(\.id))
        XCTAssertEqual(loaded.textSections.map(\.id), document.textSections.map(\.id))
        XCTAssertEqual(
            loaded.textSections.first { $0.id == sectionID }?.body,
            "Open the app, edit a flow, and save the package."
        )
    }

    func testDocumentPackageSavePreservesExistingSidecarFiles() throws {
        var document = FlowDesignDocument.newUntitled()
        let packageURL = temporaryPackageURL()
        let paperKitURL = packageURL.appendingPathComponent("paperkit", isDirectory: true)
        let sidecarURL = paperKitURL.appendingPathComponent("cached-view.paperkit")

        try FlowDesignDocumentPackageStore.save(document, to: packageURL)
        try Data("cached paperkit payload".utf8).write(to: sidecarURL)

        document.title = "Updated Flow"
        document.revision = 1
        try FlowDesignDocumentPackageStore.save(document, to: packageURL)

        XCTAssertEqual(try String(contentsOf: sidecarURL, encoding: .utf8), "cached paperkit payload")
        XCTAssertEqual(try FlowDesignDocumentPackageStore.load(from: packageURL), document)
    }

    func testDocumentPackageFileWrapperRoundTripsDocumentJSON() throws {
        var document = FlowDesignDocument.newUntitled()
        document.title = "Native Save Flow"
        document.summary = "Saved through SwiftUI document file wrappers."
        document.revision = 7

        let packageFileWrapper = try FlowDesignDocumentPackageStore.makeFileWrapper(for: document)
        let loaded = try FlowDesignDocumentPackageStore.load(from: packageFileWrapper)
        let fileWrappers = try XCTUnwrap(packageFileWrapper.fileWrappers)

        XCTAssertEqual(loaded, document)
        XCTAssertEqual(loaded.id, document.id)
        XCTAssertEqual(loaded.flowViews.map(\.id), document.flowViews.map(\.id))
        XCTAssertNotNil(fileWrappers[FlowDesignDocument.documentJSONFileName])
        XCTAssertNotNil(fileWrappers["paperkit"])
        XCTAssertNotNil(fileWrappers["previews"])
        XCTAssertNotNil(fileWrappers["provenance"])
    }

    func testDocumentPackageFileWrapperPreservesSidecars() throws {
        let document = FlowDesignDocument.newUntitled()
        let sidecarFileWrapper = FileWrapper(regularFileWithContents: Data("cached view".utf8))
        let packageFileWrapper = try FlowDesignDocumentPackageStore.makeFileWrapper(
            for: document,
            preservingSidecarsFrom: [
                "paperkit": .directory([
                    "cached-view.paperkit": .regularFile(try XCTUnwrap(sidecarFileWrapper.regularFileContents))
                ]),
                "custom-metadata.json": .regularFile(Data(#"{"owner":"tests"}"#.utf8))
            ]
        )
        let sidecars = FlowDesignDocumentPackageStore.sidecarMembers(in: packageFileWrapper)

        XCTAssertEqual(sidecars["paperkit"], .directory([
            "cached-view.paperkit": .regularFile(Data("cached view".utf8))
        ]))
        XCTAssertEqual(sidecars["custom-metadata.json"], .regularFile(Data(#"{"owner":"tests"}"#.utf8)))
        XCTAssertNil(sidecars[FlowDesignDocument.documentJSONFileName])
    }

    func testLoadingPackageWithoutDocumentJSONFails() throws {
        let packageURL = temporaryPackageURL()
        try FileManager.default.createDirectory(at: packageURL, withIntermediateDirectories: true)

        XCTAssertThrowsError(
            try FlowDesignDocumentPackageStore.load(from: packageURL)
        ) { error in
            let documentURL = packageURL.appendingPathComponent(FlowDesignDocument.documentJSONFileName)
            XCTAssertEqual(error as? FlowDesignDocumentPackageError, .missingDocumentJSON(documentURL))
        }
    }

    func testSavingPackageToExistingFileFails() throws {
        let packageURL = temporaryPackageURL()
        try Data("not a package".utf8).write(to: packageURL)

        XCTAssertThrowsError(
            try FlowDesignDocumentPackageStore.save(.newUntitled(), to: packageURL)
        ) { error in
            XCTAssertEqual(error as? FlowDesignDocumentPackageError, .packageURLIsFile(packageURL))
        }
    }

    func testLoadingPackageFileWrapperWithoutDocumentJSONFails() {
        let packageFileWrapper = FileWrapper(directoryWithFileWrappers: [
            "paperkit": FileWrapper(directoryWithFileWrappers: [:])
        ])

        XCTAssertThrowsError(
            try FlowDesignDocumentPackageStore.load(from: packageFileWrapper)
        ) { error in
            XCTAssertEqual(error as? FlowDesignDocumentPackageError, .missingDocumentJSONFileWrapper)
        }
    }

    private func temporaryPackageURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
            .appendingPathExtension("flowdesign")
    }
}
