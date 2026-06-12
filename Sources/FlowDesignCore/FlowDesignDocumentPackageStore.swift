import Foundation

public enum FlowDesignDocumentPackageStore {
    public static let paperKitDirectoryName = "paperkit"
    public static let previewsDirectoryName = "previews"
    public static let provenanceDirectoryName = "provenance"

    public static func save(
        _ document: FlowDesignDocument,
        to packageURL: URL,
        fileManager: FileManager = .default
    ) throws {
        try preparePackageDirectory(at: packageURL, fileManager: fileManager)
        try createPackageSidecarDirectories(in: packageURL, fileManager: fileManager)

        let documentURL = packageURL.appendingPathComponent(
            FlowDesignDocument.documentJSONFileName,
            isDirectory: false
        )
        try document.encodedDocumentJSON().write(to: documentURL, options: [.atomic])
    }

    public static func load(
        from packageURL: URL,
        fileManager: FileManager = .default
    ) throws -> FlowDesignDocument {
        let documentURL = packageURL.appendingPathComponent(
            FlowDesignDocument.documentJSONFileName,
            isDirectory: false
        )
        guard fileManager.fileExists(atPath: documentURL.path) else {
            throw FlowDesignDocumentPackageError.missingDocumentJSON(documentURL)
        }

        let data = try Data(contentsOf: documentURL)
        return try FlowDesignDocument.decodeDocumentJSON(from: data)
    }

    private static func preparePackageDirectory(
        at packageURL: URL,
        fileManager: FileManager
    ) throws {
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: packageURL.path, isDirectory: &isDirectory) {
            guard isDirectory.boolValue else {
                throw FlowDesignDocumentPackageError.packageURLIsFile(packageURL)
            }
            return
        }

        try fileManager.createDirectory(
            at: packageURL,
            withIntermediateDirectories: true
        )
    }

    private static func createPackageSidecarDirectories(
        in packageURL: URL,
        fileManager: FileManager
    ) throws {
        for directoryName in [
            paperKitDirectoryName,
            previewsDirectoryName,
            provenanceDirectoryName
        ] {
            let directoryURL = packageURL.appendingPathComponent(
                directoryName,
                isDirectory: true
            )
            try fileManager.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true
            )
        }
    }
}

public enum FlowDesignDocumentPackageError: Error, Equatable, Sendable {
    case missingDocumentJSON(URL)
    case packageURLIsFile(URL)
}
