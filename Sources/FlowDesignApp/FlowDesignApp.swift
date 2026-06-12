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
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Document")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextField("Document title", text: documentTitle)
                        .textFieldStyle(.roundedBorder)
                }
                .padding([.horizontal, .top], 12)

                VStack(alignment: .leading, spacing: 4) {
                    Text("App Synopsis")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextEditor(text: appSynopsisBody)
                        .font(.body)
                        .frame(minHeight: 96)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.quaternary)
                        }
                }
                .padding(.horizontal, 12)

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

    private var appSynopsisBody: Binding<String> {
        Binding(
            get: { appSynopsisSection?.body ?? "" },
            set: { body in
                guard let sectionID = appSynopsisSection?.id else {
                    return
                }
                document.updateTextSectionBody(sectionID: sectionID, body: body)
            }
        )
    }

    private var appSynopsisSection: TextSection? {
        document.textSections.first { section in
            section.owner.ownerType == .container
                && section.owner.ownerID == document.appContainerID
                && section.type == .appSynopsis
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
