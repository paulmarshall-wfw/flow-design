import AppKit
import FlowDesignCore
import PaperKit
import SwiftUI

@available(macOS 26.0, *)
public struct PaperMarkupHost: NSViewControllerRepresentable {
    public typealias NSViewControllerType = PaperMarkupViewController

    private let canvas: FlowDesignDocument.Canvas
    private let initialMarkup: PaperMarkup?
    private let isEditable: Bool

    public init(
        canvas: FlowDesignDocument.Canvas,
        initialMarkup: PaperMarkup? = nil,
        isEditable: Bool = true
    ) {
        self.canvas = canvas
        self.initialMarkup = initialMarkup
        self.isEditable = isEditable
    }

    public func makeNSViewController(context: Context) -> PaperMarkupViewController {
        let controller = PaperMarkupViewController(
            markup: initialMarkup ?? PaperMarkup(bounds: canvas.paperBounds),
            supportedFeatureSet: .latest
        )
        controller.isEditable = isEditable
        return controller
    }

    public func updateNSViewController(
        _ nsViewController: PaperMarkupViewController,
        context: Context
    ) {
        nsViewController.isEditable = isEditable
    }
}

@available(macOS 26.0, *)
extension FlowDesignDocument.Canvas {
    public var paperBounds: CGRect {
        CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
}
