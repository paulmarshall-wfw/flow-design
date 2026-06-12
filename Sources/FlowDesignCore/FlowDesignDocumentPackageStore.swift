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

    public static func load(from packageFileWrapper: FileWrapper) throws -> FlowDesignDocument {
        guard packageFileWrapper.isDirectory else {
            throw FlowDesignDocumentPackageError.packageFileWrapperIsNotDirectory
        }

        guard
            let documentFileWrapper = packageFileWrapper.fileWrappers?[FlowDesignDocument.documentJSONFileName],
            let data = documentFileWrapper.regularFileContents
        else {
            throw FlowDesignDocumentPackageError.missingDocumentJSONFileWrapper
        }

        return try FlowDesignDocument.decodeDocumentJSON(from: data)
    }

    public static func makeFileWrapper(
        for document: FlowDesignDocument,
        preservingSidecarsFrom sidecarMembers: [String: FlowDesignPackageMember] = [:]
    ) throws -> FileWrapper {
        var fileWrappers = sidecarMembers.mapValues { fileWrapper(from: $0) }

        fileWrappers[FlowDesignDocument.documentJSONFileName] = FileWrapper(
            regularFileWithContents: try document.encodedDocumentJSON()
        )

        for directoryName in [
            paperKitDirectoryName,
            previewsDirectoryName,
            provenanceDirectoryName
        ] where fileWrappers[directoryName] == nil {
            fileWrappers[directoryName] = FileWrapper(directoryWithFileWrappers: [:])
        }

        return FileWrapper(directoryWithFileWrappers: fileWrappers)
    }

    public static func sidecarMembers(
        in packageFileWrapper: FileWrapper
    ) -> [String: FlowDesignPackageMember] {
        packageFileWrapper.fileWrappers?.compactMapValues { packageMember(from: $0) }.filter { fileName, _ in
            fileName != FlowDesignDocument.documentJSONFileName
        } ?? [:]
    }

    private static func packageMember(
        from fileWrapper: FileWrapper
    ) -> FlowDesignPackageMember? {
        if fileWrapper.isDirectory {
            return .directory(
                fileWrapper.fileWrappers?.compactMapValues { packageMember(from: $0) } ?? [:]
            )
        }

        if fileWrapper.isRegularFile, let data = fileWrapper.regularFileContents {
            return .regularFile(data)
        }

        return nil
    }

    private static func fileWrapper(
        from packageMember: FlowDesignPackageMember
    ) -> FileWrapper {
        switch packageMember {
        case .regularFile(let data):
            FileWrapper(regularFileWithContents: data)
        case .directory(let members):
            FileWrapper(directoryWithFileWrappers: members.mapValues { fileWrapper(from: $0) })
        }
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

public enum FlowDesignPackageMember: Equatable, Sendable {
    case regularFile(Data)
    case directory([String: FlowDesignPackageMember])
}

public enum FlowDesignDocumentPackageError: Error, Equatable, Sendable {
    case missingDocumentJSON(URL)
    case missingDocumentJSONFileWrapper
    case packageURLIsFile(URL)
    case packageFileWrapperIsNotDirectory
}
