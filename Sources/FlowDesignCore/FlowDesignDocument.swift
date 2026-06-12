import Foundation

public struct FlowDesignDocument: Codable, Equatable, Identifiable, Sendable {
    public static let supportedSchemaVersion = "0.1.0"
    public static let documentJSONFileName = "document.json"

    public var schemaVersion: String
    public var id: UUID
    public var revision: Int
    public var title: String
    public var summary: String
    public var lifecycleState: LifecycleState
    public var createdAt: Date
    public var updatedAt: Date
    public var appContainerID: FlowContainer.ID
    public var flowViews: [FlowView]
    public var flowContainers: [FlowContainer]
    public var flowElements: [FlowElement]
    public var flowConnections: [FlowConnection]
    public var textSections: [TextSection]
    public var acceptanceCriteria: [AcceptanceCriterion]
    public var codeLinks: [CodeLink]
    public var validationFindings: [ValidationFinding]
    public var proposals: [Proposal]
    public var provenanceRecords: [ProvenanceRecord]

    public init(
        schemaVersion: String = FlowDesignDocument.supportedSchemaVersion,
        id: UUID = UUID(),
        revision: Int = 0,
        title: String,
        summary: String = "",
        lifecycleState: LifecycleState = .draft,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        appContainerID: FlowContainer.ID,
        flowViews: [FlowView],
        flowContainers: [FlowContainer],
        flowElements: [FlowElement] = [],
        flowConnections: [FlowConnection] = [],
        textSections: [TextSection] = [],
        acceptanceCriteria: [AcceptanceCriterion] = [],
        codeLinks: [CodeLink] = [],
        validationFindings: [ValidationFinding] = [],
        proposals: [Proposal] = [],
        provenanceRecords: [ProvenanceRecord] = []
    ) {
        self.schemaVersion = schemaVersion
        self.id = id
        self.revision = revision
        self.title = title
        self.summary = summary
        self.lifecycleState = lifecycleState
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.appContainerID = appContainerID
        self.flowViews = flowViews
        self.flowContainers = flowContainers
        self.flowElements = flowElements
        self.flowConnections = flowConnections
        self.textSections = textSections
        self.acceptanceCriteria = acceptanceCriteria
        self.codeLinks = codeLinks
        self.validationFindings = validationFindings
        self.proposals = proposals
        self.provenanceRecords = provenanceRecords
    }

    public static func newUntitled() -> FlowDesignDocument {
        let now = Date()
        let documentID = UUID()
        let appContainerID = UUID()
        let viewTypes: [FlowView.ViewType] = [
            .appOverview,
            .happyPath,
            .componentLogic,
            .failurePath
        ]
        let flowViews = viewTypes.map { viewType in
            let viewID = UUID()
            return FlowView(
                id: viewID,
                type: viewType,
                name: viewType.defaultName,
                description: "",
                rootAppContainerID: appContainerID,
                objectIDs: [appContainerID],
                connectionIDs: [],
                acceptanceCriterionIDs: [],
                validationFindingIDs: [],
                layout: FlowView.Layout(canvasSize: .default),
                createdAt: now,
                updatedAt: now
            )
        }
        let appContainer = FlowContainer(
            id: appContainerID,
            containerType: .appContainer,
            label: "App",
            notes: "",
            layoutFrames: flowViews.map { view in
                ViewGeometry(
                    viewID: view.id,
                    frame: Geometry(x: 120, y: 120, width: 1360, height: 840)
                )
            },
            parentContainerID: nil,
            childObjectIDs: [],
            textSectionIDs: [],
            acceptanceCriterionIDs: [],
            codeLinkIDs: [],
            provenanceID: nil,
            viewIDs: flowViews.map(\.id)
        )
        var textSections = TextSection.defaultAppSections(
            ownerID: appContainerID,
            updatedAt: now
        )
        textSections.append(
            contentsOf: flowViews.flatMap { view in
                TextSection.defaultViewSections(ownerID: view.id, updatedAt: now)
            }
        )

        return FlowDesignDocument(
            id: documentID,
            title: "Untitled Flow",
            createdAt: now,
            updatedAt: now,
            appContainerID: appContainerID,
            flowViews: flowViews,
            flowContainers: [appContainer],
            textSections: textSections
        )
    }

    public var canvases: [Canvas] {
        flowViews.map { view in
            Canvas(id: view.id, name: view.name, size: view.layout.canvasSize)
        }
    }

    public var appContainer: FlowContainer? {
        flowContainers.first { $0.id == appContainerID && $0.containerType == .appContainer }
    }

    public func textSections(ownerType: TextOwnerReference.OwnerType, ownerID: UUID) -> [TextSection] {
        textSections.filter { section in
            section.owner.ownerType == ownerType && section.owner.ownerID == ownerID
        }
    }

    public func encodedDocumentJSON() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        return try encoder.encode(self)
    }

    public static func decodeDocumentJSON(from data: Data) throws -> FlowDesignDocument {
        let header = try JSONDecoder().decode(DocumentHeader.self, from: data)
        guard header.schemaVersion == supportedSchemaVersion else {
            throw FlowDesignDocumentError.unsupportedSchemaVersion(header.schemaVersion)
        }
        return try JSONDecoder().decode(FlowDesignDocument.self, from: data)
    }
}

public enum FlowDesignDocumentError: Error, Equatable, Sendable {
    case unsupportedSchemaVersion(String)
}

private struct DocumentHeader: Decodable {
    var schemaVersion: String
}

extension FlowDesignDocument {
    public enum LifecycleState: String, Codable, Equatable, Sendable {
        case draft
        case codexProposed = "codex_proposed"
        case userReviewed = "user_reviewed"
        case implementationReady = "implementation_ready"
        case linkedToExistingApp = "linked_to_existing_app"
        case rescanAvailable = "rescan_available"
        case outOfSyncWithSource = "out_of_sync_with_source"
    }
}

extension FlowDesignDocument {
    public struct Canvas: Equatable, Identifiable, Sendable {
        public var id: UUID
        public var name: String
        public var size: CanvasSize

        public init(
            id: UUID = UUID(),
            name: String,
            size: CanvasSize
        ) {
            self.id = id
            self.name = name
            self.size = size
        }
    }

    public struct CanvasSize: Equatable, Sendable {
        public var width: Double
        public var height: Double

        public init(width: Double, height: Double) {
            self.width = width
            self.height = height
        }

        public static let `default` = CanvasSize(width: 1600, height: 1200)
    }
}

public struct FlowView: Codable, Equatable, Identifiable, Sendable {
    public var id: UUID
    public var type: ViewType
    public var name: String
    public var description: String
    public var rootAppContainerID: FlowContainer.ID
    public var objectIDs: [UUID]
    public var connectionIDs: [FlowConnection.ID]
    public var acceptanceCriterionIDs: [AcceptanceCriterion.ID]
    public var validationFindingIDs: [ValidationFinding.ID]
    public var activeTraceSubview: TraceSubview?
    public var layout: Layout
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        type: ViewType,
        name: String,
        description: String = "",
        rootAppContainerID: FlowContainer.ID,
        objectIDs: [UUID],
        connectionIDs: [FlowConnection.ID] = [],
        acceptanceCriterionIDs: [AcceptanceCriterion.ID] = [],
        validationFindingIDs: [ValidationFinding.ID] = [],
        activeTraceSubview: TraceSubview? = nil,
        layout: Layout = Layout(),
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.description = description
        self.rootAppContainerID = rootAppContainerID
        self.objectIDs = objectIDs
        self.connectionIDs = connectionIDs
        self.acceptanceCriterionIDs = acceptanceCriterionIDs
        self.validationFindingIDs = validationFindingIDs
        self.activeTraceSubview = activeTraceSubview
        self.layout = layout
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension FlowView {
    public enum ViewType: String, Codable, Equatable, Sendable {
        case appOverview = "app_overview"
        case happyPath = "happy_path"
        case componentLogic = "component_logic"
        case failurePath = "failure_path"

        public var defaultName: String {
            switch self {
            case .appOverview:
                "App Overview"
            case .happyPath:
                "Happy Path"
            case .componentLogic:
                "Component Logic"
            case .failurePath:
                "Failure Path"
            }
        }
    }

    public enum TraceSubview: String, Codable, Equatable, Sendable {
        case sourceLinks = "source_links"
        case changeImpact = "change_impact"
    }

    public struct Layout: Codable, Equatable, Sendable {
        public var canvasSize: FlowDesignDocument.CanvasSize
        public var zoomScale: Double
        public var viewportOrigin: Point

        public init(
            canvasSize: FlowDesignDocument.CanvasSize = .default,
            zoomScale: Double = 1,
            viewportOrigin: Point = Point()
        ) {
            self.canvasSize = canvasSize
            self.zoomScale = zoomScale
            self.viewportOrigin = viewportOrigin
        }
    }
}

public struct FlowContainer: Codable, Equatable, Identifiable, Sendable {
    public var id: UUID
    public var containerType: ContainerType
    public var label: String
    public var notes: String
    public var layoutFrames: [ViewGeometry]
    public var parentContainerID: UUID?
    public var childObjectIDs: [UUID]
    public var textSectionIDs: [TextSection.ID]
    public var acceptanceCriterionIDs: [AcceptanceCriterion.ID]
    public var codeLinkIDs: [CodeLink.ID]
    public var provenanceID: ProvenanceRecord.ID?
    public var viewIDs: [FlowView.ID]

    public init(
        id: UUID = UUID(),
        containerType: ContainerType,
        label: String,
        notes: String = "",
        layoutFrames: [ViewGeometry] = [],
        parentContainerID: UUID? = nil,
        childObjectIDs: [UUID] = [],
        textSectionIDs: [TextSection.ID] = [],
        acceptanceCriterionIDs: [AcceptanceCriterion.ID] = [],
        codeLinkIDs: [CodeLink.ID] = [],
        provenanceID: ProvenanceRecord.ID? = nil,
        viewIDs: [FlowView.ID] = []
    ) {
        self.id = id
        self.containerType = containerType
        self.label = label
        self.notes = notes
        self.layoutFrames = layoutFrames
        self.parentContainerID = parentContainerID
        self.childObjectIDs = childObjectIDs
        self.textSectionIDs = textSectionIDs
        self.acceptanceCriterionIDs = acceptanceCriterionIDs
        self.codeLinkIDs = codeLinkIDs
        self.provenanceID = provenanceID
        self.viewIDs = viewIDs
    }

    public enum ContainerType: String, Codable, Equatable, Sendable {
        case appContainer = "app_container"
        case subflowModuleContainer = "subflow_module_container"
    }
}

public struct FlowElement: Codable, Equatable, Identifiable, Sendable {
    public var id: UUID
    public var elementType: ElementType
    public var label: String
    public var notes: String
    public var layoutFrames: [ViewGeometry]
    public var parentContainerID: FlowContainer.ID
    public var acceptanceCriterionIDs: [AcceptanceCriterion.ID]
    public var codeLinkIDs: [CodeLink.ID]
    public var provenanceID: ProvenanceRecord.ID?
    public var viewIDs: [FlowView.ID]
    public var terminalOutcome: TerminalOutcome?
    public var properties: [String: String]

    public init(
        id: UUID = UUID(),
        elementType: ElementType,
        label: String,
        notes: String = "",
        layoutFrames: [ViewGeometry] = [],
        parentContainerID: FlowContainer.ID,
        acceptanceCriterionIDs: [AcceptanceCriterion.ID] = [],
        codeLinkIDs: [CodeLink.ID] = [],
        provenanceID: ProvenanceRecord.ID? = nil,
        viewIDs: [FlowView.ID] = [],
        terminalOutcome: TerminalOutcome? = nil,
        properties: [String: String] = [:]
    ) {
        self.id = id
        self.elementType = elementType
        self.label = label
        self.notes = notes
        self.layoutFrames = layoutFrames
        self.parentContainerID = parentContainerID
        self.acceptanceCriterionIDs = acceptanceCriterionIDs
        self.codeLinkIDs = codeLinkIDs
        self.provenanceID = provenanceID
        self.viewIDs = viewIDs
        self.terminalOutcome = terminalOutcome
        self.properties = properties
    }

    public enum ElementType: String, Codable, Equatable, Sendable {
        case startEnd = "start_end"
        case process
        case decision
        case inputOutput = "input_output"
        case dataStore = "data_store"
        case document
        case connector
        case actorSystemBoundary = "actor_system_boundary"
        case retryStep = "retry_step"
        case terminalOutcome = "terminal_outcome"
        case annotation
    }

    public enum TerminalOutcome: String, Codable, Equatable, Sendable {
        case success
        case failure
        case cancellation
        case timeout
    }
}

public struct FlowConnection: Codable, Equatable, Identifiable, Sendable {
    public var id: UUID
    public var source: FlowObjectReference
    public var target: FlowObjectReference
    public var direction: Direction
    public var label: String
    public var conditionText: String
    public var relationshipType: RelationshipType
    public var provenanceID: ProvenanceRecord.ID?
    public var route: [Point]

    public init(
        id: UUID = UUID(),
        source: FlowObjectReference,
        target: FlowObjectReference,
        direction: Direction = .directed,
        label: String = "",
        conditionText: String = "",
        relationshipType: RelationshipType = .controlFlow,
        provenanceID: ProvenanceRecord.ID? = nil,
        route: [Point] = []
    ) {
        self.id = id
        self.source = source
        self.target = target
        self.direction = direction
        self.label = label
        self.conditionText = conditionText
        self.relationshipType = relationshipType
        self.provenanceID = provenanceID
        self.route = route
    }

    public enum Direction: String, Codable, Equatable, Sendable {
        case directed
    }

    public enum RelationshipType: String, Codable, Equatable, Sendable {
        case controlFlow = "control_flow"
        case dataFlow = "data_flow"
        case dependency
        case annotation
    }
}

public struct TextSection: Codable, Equatable, Identifiable, Sendable {
    public var id: UUID
    public var owner: TextOwnerReference
    public var type: SectionType
    public var title: String
    public var body: String
    public var linkedViewIDs: [FlowView.ID]
    public var linkedElementIDs: [FlowElement.ID]
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        owner: TextOwnerReference,
        type: SectionType,
        title: String,
        body: String = "",
        linkedViewIDs: [FlowView.ID] = [],
        linkedElementIDs: [FlowElement.ID] = [],
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.owner = owner
        self.type = type
        self.title = title
        self.body = body
        self.linkedViewIDs = linkedViewIDs
        self.linkedElementIDs = linkedElementIDs
        self.updatedAt = updatedAt
    }

    public enum SectionType: String, Codable, Equatable, Sendable {
        case appSynopsis = "app_synopsis"
        case majorFeatures = "major_features"
        case happyPathDescription = "happy_path_description"
        case logicDescription = "logic_description"
        case description
        case notes
        case acceptanceCriteria = "acceptance_criteria"
        case viewDescription = "view_description"
    }

    public static func defaultAppSections(ownerID: UUID, updatedAt: Date) -> [TextSection] {
        [
            TextSection(
                owner: TextOwnerReference(ownerType: .container, ownerID: ownerID),
                type: .appSynopsis,
                title: "App Synopsis",
                updatedAt: updatedAt
            ),
            TextSection(
                owner: TextOwnerReference(ownerType: .container, ownerID: ownerID),
                type: .majorFeatures,
                title: "Major Features",
                updatedAt: updatedAt
            ),
            TextSection(
                owner: TextOwnerReference(ownerType: .container, ownerID: ownerID),
                type: .happyPathDescription,
                title: "Happy Path Description",
                updatedAt: updatedAt
            ),
            TextSection(
                owner: TextOwnerReference(ownerType: .container, ownerID: ownerID),
                type: .logicDescription,
                title: "Logic Description",
                updatedAt: updatedAt
            )
        ]
    }

    public static func defaultViewSections(ownerID: UUID, updatedAt: Date) -> [TextSection] {
        [
            TextSection(
                owner: TextOwnerReference(ownerType: .view, ownerID: ownerID),
                type: .viewDescription,
                title: "View Description",
                updatedAt: updatedAt
            ),
            TextSection(
                owner: TextOwnerReference(ownerType: .view, ownerID: ownerID),
                type: .acceptanceCriteria,
                title: "Acceptance Criteria",
                updatedAt: updatedAt
            )
        ]
    }
}

public struct AcceptanceCriterion: Codable, Equatable, Identifiable, Sendable {
    public var id: UUID
    public var owner: TextOwnerReference
    public var text: String
    public var status: Status
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        owner: TextOwnerReference,
        text: String,
        status: Status = .open,
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.owner = owner
        self.text = text
        self.status = status
        self.updatedAt = updatedAt
    }

    public enum Status: String, Codable, Equatable, Sendable {
        case open
        case satisfied
        case blocked
    }
}

public struct CodeLink: Codable, Equatable, Identifiable, Sendable {
    public var id: UUID
    public var owner: TextOwnerReference
    public var linkType: LinkType
    public var repositoryPath: String
    public var reference: String
    public var scanSnapshotID: UUID?
    public var displayLabel: String

    public init(
        id: UUID = UUID(),
        owner: TextOwnerReference,
        linkType: LinkType,
        repositoryPath: String,
        reference: String = "",
        scanSnapshotID: UUID? = nil,
        displayLabel: String
    ) {
        self.id = id
        self.owner = owner
        self.linkType = linkType
        self.repositoryPath = repositoryPath
        self.reference = reference
        self.scanSnapshotID = scanSnapshotID
        self.displayLabel = displayLabel
    }

    public enum LinkType: String, Codable, Equatable, Sendable {
        case file
        case module
        case symbol
        case document
        case command
    }
}

public struct ValidationFinding: Codable, Equatable, Identifiable, Sendable {
    public var id: UUID
    public var ruleID: String
    public var severity: Severity
    public var message: String
    public var affectedViewID: FlowView.ID?
    public var affectedElementIDs: [FlowElement.ID]
    public var affectedContainerIDs: [FlowContainer.ID]
    public var affectedConnectionIDs: [FlowConnection.ID]
    public var sourceType: SourceType
    public var resolutionState: ResolutionState

    public init(
        id: UUID = UUID(),
        ruleID: String,
        severity: Severity,
        message: String,
        affectedViewID: FlowView.ID? = nil,
        affectedElementIDs: [FlowElement.ID] = [],
        affectedContainerIDs: [FlowContainer.ID] = [],
        affectedConnectionIDs: [FlowConnection.ID] = [],
        sourceType: SourceType = .deterministic,
        resolutionState: ResolutionState = .open
    ) {
        self.id = id
        self.ruleID = ruleID
        self.severity = severity
        self.message = message
        self.affectedViewID = affectedViewID
        self.affectedElementIDs = affectedElementIDs
        self.affectedContainerIDs = affectedContainerIDs
        self.affectedConnectionIDs = affectedConnectionIDs
        self.sourceType = sourceType
        self.resolutionState = resolutionState
    }

    public enum Severity: String, Codable, Equatable, Sendable {
        case info
        case warning
        case error
    }

    public enum SourceType: String, Codable, Equatable, Sendable {
        case deterministic
        case heuristic
        case codex
    }

    public enum ResolutionState: String, Codable, Equatable, Sendable {
        case open
        case dismissed
        case resolved
    }
}

public struct Proposal: Codable, Equatable, Identifiable, Sendable {
    public var id: UUID
    public var baseDocumentRevision: Int
    public var sourceInstruction: String
    public var semanticPatchJSON: String
    public var validationFindingIDs: [ValidationFinding.ID]
    public var conflictState: ConflictState
    public var reviewState: ReviewState
    public var provenanceIDs: [ProvenanceRecord.ID]

    public init(
        id: UUID = UUID(),
        baseDocumentRevision: Int,
        sourceInstruction: String,
        semanticPatchJSON: String,
        validationFindingIDs: [ValidationFinding.ID] = [],
        conflictState: ConflictState = .none,
        reviewState: ReviewState = .pending,
        provenanceIDs: [ProvenanceRecord.ID] = []
    ) {
        self.id = id
        self.baseDocumentRevision = baseDocumentRevision
        self.sourceInstruction = sourceInstruction
        self.semanticPatchJSON = semanticPatchJSON
        self.validationFindingIDs = validationFindingIDs
        self.conflictState = conflictState
        self.reviewState = reviewState
        self.provenanceIDs = provenanceIDs
    }

    public enum ConflictState: String, Codable, Equatable, Sendable {
        case none
        case needsReview = "needs_review"
        case conflicted
    }

    public enum ReviewState: String, Codable, Equatable, Sendable {
        case pending
        case accepted
        case partiallyAccepted = "partially_accepted"
        case rejected
    }
}

public struct ProvenanceRecord: Codable, Equatable, Identifiable, Sendable {
    public var id: UUID
    public var actorType: ActorType
    public var summary: String
    public var sourceReferences: [String]
    public var providerName: String?
    public var modelName: String?
    public var createdAt: Date
    public var supersededByID: ProvenanceRecord.ID?

    public init(
        id: UUID = UUID(),
        actorType: ActorType,
        summary: String,
        sourceReferences: [String] = [],
        providerName: String? = nil,
        modelName: String? = nil,
        createdAt: Date = Date(),
        supersededByID: ProvenanceRecord.ID? = nil
    ) {
        self.id = id
        self.actorType = actorType
        self.summary = summary
        self.sourceReferences = sourceReferences
        self.providerName = providerName
        self.modelName = modelName
        self.createdAt = createdAt
        self.supersededByID = supersededByID
    }

    public enum ActorType: String, Codable, Equatable, Sendable {
        case user
        case codex
        case system
    }
}

public struct FlowObjectReference: Codable, Equatable, Sendable {
    public var objectType: ObjectType
    public var objectID: UUID

    public init(objectType: ObjectType, objectID: UUID) {
        self.objectType = objectType
        self.objectID = objectID
    }

    public enum ObjectType: String, Codable, Equatable, Sendable {
        case element
        case container
    }
}

public struct TextOwnerReference: Codable, Equatable, Sendable {
    public var ownerType: OwnerType
    public var ownerID: UUID

    public init(ownerType: OwnerType, ownerID: UUID) {
        self.ownerType = ownerType
        self.ownerID = ownerID
    }

    public enum OwnerType: String, Codable, Equatable, Sendable {
        case view
        case element
        case container
    }
}

public struct ViewGeometry: Codable, Equatable, Sendable {
    public var viewID: FlowView.ID
    public var frame: Geometry

    public init(viewID: FlowView.ID, frame: Geometry) {
        self.viewID = viewID
        self.frame = frame
    }
}

public struct Geometry: Codable, Equatable, Sendable {
    public var x: Double
    public var y: Double
    public var width: Double
    public var height: Double

    public init(x: Double, y: Double, width: Double, height: Double) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
}

public struct Point: Codable, Equatable, Sendable {
    public var x: Double
    public var y: Double

    public init(x: Double = 0, y: Double = 0) {
        self.x = x
        self.y = y
    }
}

extension FlowDesignDocument.CanvasSize: Codable {}
