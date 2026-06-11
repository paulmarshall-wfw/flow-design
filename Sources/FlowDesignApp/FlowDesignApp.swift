import FlowDesignCore
import FlowDesignPaperKit
import SwiftUI

@main
struct FlowDesignApp: App {
    @State private var document = FlowDesignDocument.newUntitled()
    @State private var selectedCanvasID: FlowDesignDocument.Canvas.ID?

    var body: some Scene {
        WindowGroup {
            FlowDesignWorkspaceView(
                document: document,
                selectedCanvasID: $selectedCanvasID
            )
        }
        .commands {
            FlowDesignCommands()
        }
    }
}

private struct FlowDesignWorkspaceView: View {
    let document: FlowDesignDocument
    @Binding var selectedCanvasID: FlowDesignDocument.Canvas.ID?

    var body: some View {
        NavigationSplitView {
            List(document.canvases, selection: $selectedCanvasID) { canvas in
                Text(canvas.name)
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
}

private struct FlowDesignCommands: Commands {
    var body: some Commands {
        CommandGroup(after: .newItem) {
            Button("New Canvas") {
                // Hook this into document mutation once persistence is defined.
            }
            .disabled(true)
        }
    }
}
