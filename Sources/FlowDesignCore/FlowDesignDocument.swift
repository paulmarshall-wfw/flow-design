import Foundation

public struct FlowDesignDocument: Equatable, Identifiable, Sendable {
    public var id: UUID
    public var title: String
    public var canvases: [Canvas]

    public init(
        id: UUID = UUID(),
        title: String,
        canvases: [Canvas] = []
    ) {
        self.id = id
        self.title = title
        self.canvases = canvases
    }

    public static func newUntitled() -> FlowDesignDocument {
        FlowDesignDocument(
            title: "Untitled Flow",
            canvases: [
                Canvas(name: "Canvas 1", size: .default)
            ]
        )
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
