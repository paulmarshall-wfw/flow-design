import FlowDesignCore
import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let flowDesignDocument = UTType(
        exportedAs: "com.paulmarshall.flow-design.document",
        conformingTo: .package
    )
}

struct FlowDesignFileDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [.flowDesignDocument]
    }

    static var writableContentTypes: [UTType] {
        [.flowDesignDocument]
    }

    var flowDocument: FlowDesignDocument
    private var packageSidecarMembers: [String: FlowDesignPackageMember]

    init(
        flowDocument: FlowDesignDocument = .newUntitled(),
        packageSidecarMembers: [String: FlowDesignPackageMember] = [:]
    ) {
        self.flowDocument = flowDocument
        self.packageSidecarMembers = packageSidecarMembers
    }

    init(configuration: ReadConfiguration) throws {
        flowDocument = try FlowDesignDocumentPackageStore.load(from: configuration.file)
        packageSidecarMembers = FlowDesignDocumentPackageStore.sidecarMembers(
            in: configuration.file
        )
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        try FlowDesignDocumentPackageStore.makeFileWrapper(
            for: flowDocument,
            preservingSidecarsFrom: packageSidecarMembers
        )
    }
}
