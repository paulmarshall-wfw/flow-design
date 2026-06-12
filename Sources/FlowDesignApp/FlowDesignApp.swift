import FlowDesignCore
import FlowDesignPaperKit
import SwiftUI

@main
struct FlowDesignApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: FlowDesignFileDocument()) { file in
            FlowDesignDocumentSceneView(document: file.$document.flowDocument)
        }
        .commands {
            FlowDesignCommands()
        }
    }
}

private struct FlowDesignDocumentSceneView: View {
    @Binding var document: FlowDesignDocument
    @State private var selectedCanvasID: FlowDesignDocument.Canvas.ID?

    var body: some View {
        FlowDesignWorkspaceView(
            document: $document,
            selectedCanvasID: $selectedCanvasID
        )
    }
}

private struct FlowDesignWorkspaceView: View {
    @Binding var document: FlowDesignDocument
    @Binding var selectedCanvasID: FlowDesignDocument.Canvas.ID?
    @Environment(\.undoManager) private var undoManager
    @State private var showsSelectedViewTextSections = true

    var body: some View {
        NavigationSplitView {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Document")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("Document title", text: documentTitle)
                                .textFieldStyle(.roundedBorder)
                        }

                        AppTextSectionsView(
                            document: $document,
                            setTextSectionBody: setTextSectionBody
                        )
                    }
                    .padding([.horizontal, .top], 12)
                    .padding(.bottom, 8)
                }

                Divider()

                List(document.canvases, selection: $selectedCanvasID) { canvas in
                    Text(canvas.name)
                }

                if showsSelectedViewTextSections {
                    Divider()

                    SelectedViewTextSectionsView(
                        document: $document,
                        selectedViewID: selectedCanvasID,
                        setTextSectionBody: setTextSectionBody
                    )
                    .padding([.horizontal, .bottom], 12)
                    .padding(.top, 10)
                }
            }
            .navigationTitle(document.title)
        } detail: {
            if let canvas = selectedCanvas {
                PaperMarkupHost(canvas: canvas)
                    .ignoresSafeArea()
            } else {
                ContentUnavailableView(
                    "Select a canvas",
                    systemImage: "square.on.square",
                    description: Text("Choose a canvas from the sidebar.")
                )
            }
        }
        .onAppear {
            selectedCanvasID = selectedCanvasID ?? document.canvases.first?.id
        }
        .focusedSceneValue(\.flowDesignDocumentCommands, documentCommandContext)
    }

    private var selectedCanvas: FlowDesignDocument.Canvas? {
        document.canvases.first { $0.id == selectedCanvasID }
    }

    private var documentCommandContext: FlowDesignDocumentCommandContext {
        FlowDesignDocumentCommandContext(
            selectedViewName: selectedCanvas?.name,
            showSelectedViewText: {
                showsSelectedViewTextSections = true
            }
        )
    }

    private var documentTitle: Binding<String> {
        Binding(
            get: { document.title },
            set: { setDocumentTitle($0) }
        )
    }

    private func setDocumentTitle(_ title: String) {
        let oldTitle = document.title
        guard oldTitle != title else {
            return
        }

        guard document.updateTitle(title) else {
            return
        }

        registerUndo(actionName: "Edit Document Title") {
            setDocumentTitle(oldTitle)
        }
    }

    private func setTextSectionBody(sectionID: TextSection.ID, body: String) {
        guard let section = document.textSection(id: sectionID) else {
            return
        }
        let oldBody = section.body
        guard oldBody != body else {
            return
        }

        guard document.updateTextSectionBody(sectionID: sectionID, body: body) else {
            return
        }

        registerUndo(actionName: "Edit \(section.title)") {
            setTextSectionBody(sectionID: sectionID, body: oldBody)
        }
    }

    private func registerUndo(actionName: String, action: @escaping () -> Void) {
        guard let undoManager else {
            return
        }

        let undoAction = FlowDesignUndoAction(action: action)
        undoManager.registerUndo(withTarget: undoAction) { target in
            target.perform()
        }
        undoManager.setActionName(actionName)
    }
}

private struct AppTextSectionsView: View {
    @Binding var document: FlowDesignDocument
    var setTextSectionBody: (TextSection.ID, String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(document.appTextSections) { section in
                VStack(alignment: .leading, spacing: 4) {
                    Text(section.title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextEditor(text: textSectionBody(sectionID: section.id))
                        .font(.body)
                        .frame(minHeight: editorHeight(for: section.type))
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.quaternary)
                        }
                }
            }
        }
    }

    private func textSectionBody(sectionID: TextSection.ID) -> Binding<String> {
        Binding(
            get: { document.textSection(id: sectionID)?.body ?? "" },
            set: { body in
                setTextSectionBody(sectionID, body)
            }
        )
    }

    private func editorHeight(for sectionType: TextSection.SectionType) -> CGFloat {
        switch sectionType {
        case .appSynopsis:
            96
        default:
            80
        }
    }
}

private struct SelectedViewTextSectionsView: View {
    @Binding var document: FlowDesignDocument
    var selectedViewID: FlowView.ID?
    var setTextSectionBody: (TextSection.ID, String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let selectedViewID, let view = document.flowView(id: selectedViewID) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Selected View")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(view.name)
                        .font(.headline)
                }

                ForEach(document.viewTextSections(viewID: selectedViewID)) { section in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(section.title)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextEditor(text: textSectionBody(sectionID: section.id))
                            .font(.body)
                            .frame(minHeight: editorHeight(for: section.type))
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.quaternary)
                            }
                    }
                }
            } else {
                Text("Select a view to edit view text.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func textSectionBody(sectionID: TextSection.ID) -> Binding<String> {
        Binding(
            get: { document.textSection(id: sectionID)?.body ?? "" },
            set: { body in
                setTextSectionBody(sectionID, body)
            }
        )
    }

    private func editorHeight(for sectionType: TextSection.SectionType) -> CGFloat {
        switch sectionType {
        case .acceptanceCriteria:
            80
        default:
            96
        }
    }
}

private struct FlowDesignCommands: Commands {
    @FocusedValue(\.flowDesignDocumentCommands) private var documentCommands

    var body: some Commands {
        CommandMenu("Flow") {
            Button("Show Selected View Text") {
                documentCommands?.showSelectedViewText()
            }
            .keyboardShortcut("t", modifiers: [.command, .option])
            .disabled(documentCommands?.canShowSelectedViewText != true)

            Button("New Canvas") {
                // Hook this into document mutation once canvas editing is defined.
            }
            .disabled(true)
        }
    }
}

private struct FlowDesignDocumentCommandContext {
    var selectedViewName: String?
    var showSelectedViewText: () -> Void

    var canShowSelectedViewText: Bool {
        selectedViewName != nil
    }
}

private struct FlowDesignDocumentCommandsKey: FocusedValueKey {
    typealias Value = FlowDesignDocumentCommandContext
}

private extension FocusedValues {
    var flowDesignDocumentCommands: FlowDesignDocumentCommandContext? {
        get { self[FlowDesignDocumentCommandsKey.self] }
        set { self[FlowDesignDocumentCommandsKey.self] = newValue }
    }
}

private final class FlowDesignUndoAction: NSObject {
    private let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    @objc func perform() {
        action()
    }
}
