# Apple Framework Notes

## Included In The Initial Scaffold

- SwiftUI: primary app shell and navigation.
- AppKit: required bridge surface for PaperKit view controllers and native macOS behavior.
- PaperKit: canvas markup surface, markup persistence, rendering, shapes, text, images, and toolbar integration.
- PencilKit: drawing tools and drawing data that PaperKit imports and interoperates with.
- Foundation: core value types, persistence primitives, and app infrastructure.
- UniformTypeIdentifiers: future document type registration, including PaperKit's `UTType.paperkit`.

## Useful Frameworks To Consider Next

- PDFKit: exporting, importing, annotating, or previewing PDF-based flows.
- CoreGraphics: custom drawing, rendering, hit testing, and export pipelines.
- CoreImage: image filtering or raster processing for imported assets.
- ImageIO: reading and writing image metadata and formats.
- Metal and MetalKit: accelerated canvas rendering if PaperKit plus SwiftUI is not enough for large documents.
- QuickLook and QuickLookUI: Finder previews and in-app previews for flow documents.
- CoreTransferable: drag-and-drop and pasteboard exchange for app content.
- FileProvider or FileProviderUI: deeper document syncing or provider integration if files become collaborative.
- CloudKit: iCloud document sync if the app needs Apple-account-backed storage.
- AppIntents: Shortcuts, Spotlight, and system automation surfaces.
- Spotlight: indexing document content beyond PaperKit's own indexable markup text.
- Observation: app state models on macOS 14+ and modern Apple platforms.
- os: structured logging through `Logger`.
- MetricKit: runtime diagnostics after the app becomes user-testable.

## Version Note

The local SDK inspected during setup was `MacOSX26.5.sdk`. PaperKit symbols in that SDK are marked available from macOS 26.0.
