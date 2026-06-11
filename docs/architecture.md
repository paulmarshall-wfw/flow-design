# Architecture

## Product Shape

Flow Design is an Apple-native macOS document editor for creating, explaining, and maintaining standard flowcharts. The default implementation direction is Swift, SwiftUI, async/await, and Observation-based state on modern targets.

The product foundation is captured in [Product Fundamentals](product-fundamentals.md).

## Boundaries

- `FlowDesignApp` owns the window, navigation, commands, and app lifecycle.
- `FlowDesignCore` owns document and canvas domain types that should stay free of UI framework assumptions.
- `FlowDesignPaperKit` owns PaperKit, PencilKit, AppKit, and SwiftUI bridge code.
- `Resources` holds future app bundle resources such as assets, icons, previews, and document-type resources.

## Domain Direction

`FlowDesignCore` should model semantic flow data separately from rendered PaperKit markup. Flow documents should preserve stable flow elements, connections, text sections, view types, and provenance so both users and Codex can edit the same flow safely.

PaperKit remains the native interaction and rendering surface. It should not become the only source of truth for app flow meaning.

Flow Design should use a native document package as the durable artifact. The package should store canonical semantic flow data in JSON and keep PaperKit data, previews, and provenance as separate package members.

## PaperKit Integration

The installed macOS 26.5 SDK exposes PaperKit as a Swift module. The scaffold uses `PaperMarkupViewController`, `PaperMarkup`, and `FeatureSet.latest` behind a dedicated adapter target so app code does not depend directly on PaperKit symbols everywhere.

## Verification

The initial root verification path is:

```bash
swift build
swift test
```

Add app-bundle build verification after the Xcode project or project-generation path exists.
