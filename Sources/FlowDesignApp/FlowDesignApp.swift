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

                        AppTextSectionsView(document: $document)
                    }
                    .padding([.horizontal, .top], 12)
                    .padding(.bottom, 8)
                }

                Divider()

                List(document.canvases, selection: $selectedCanvasID) { canvas in
                    Text(canvas.name)
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
    }

    private var selectedCanvas: FlowDesignDocument.Canvas? {
        document.canvases.first { $0.id == selectedCanvasID }
    }

    private var documentTitle: Binding<String> {
        Binding(
            get: { document.title },
            set: { document.updateTitle($0) }
        )
    }
}

private struct AppTextSectionsView: View {
    @Binding var document: FlowDesignDocument

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
                document.updateTextSectionBody(sectionID: sectionID, body: body)
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

private struct FlowDesignCommands: Commands {
    var body: some Commands {
        CommandGroup(after: .newItem) {
            Button("New Canvas") {
                // Hook this into document mutation once canvas editing is defined.
            }
            .disabled(true)
        }
    }
}
