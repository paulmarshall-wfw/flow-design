# Flow Design

Flow Design is a native macOS app scaffold for designing, explaining, and maintaining application flows with standard flowcharts on a PaperKit-backed canvas.

## Stack

- Swift
- SwiftUI
- AppKit interop where PaperKit exposes view controllers
- PaperKit and PencilKit from the macOS 26 SDK
- XCTest for the initial core test target

## Requirements

- macOS SDK 26.5 or newer
- Apple Swift 6.3 or newer

The current local SDK check found `MacOSX26.5.sdk` and Apple Swift 6.3.2.

## Repository Shape

- `Sources/FlowDesignApp`: SwiftUI app shell and command surface
- `Sources/FlowDesignCore`: app domain model and testable non-UI logic
- `Sources/FlowDesignPaperKit`: PaperKit/AppKit/SwiftUI bridge
- `Tests/FlowDesignCoreTests`: XCTest coverage for core behavior
- `Resources`: app assets and preview content for a future Xcode app target
- `docs`: architecture and framework notes
- `scripts`: deterministic project maintenance helpers
- `config`: non-secret project configuration

## Product Definition

- [Product requirements document](docs/prd-unified-v2.md): active PRD for goals, user stories, requirements, AI/provider behavior, data model, MVP scope, and open product questions.
- [Product fundamentals](docs/product-fundamentals.md): intent, core concepts, workspace shape, Codex assistance, library, and first usable product scope.
- [Architecture](docs/architecture.md): target boundaries, PaperKit integration, provider-registry alignment, and verification path.
- [Provider registry alignment review](docs/review/flow-design-provider-registry-alignment.md): review input that the active docs now incorporate for provider-backed AI boundaries.

## Build And Test

```bash
swift build
swift test
```

## Xcode App Bundle

The repo keeps source in the SwiftPM-friendly `Sources/` and `Tests/` layout, then generates a local Xcode project for the macOS app bundle:

```bash
python3 scripts/generate_xcode_project.py
xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO build
```

Launch and verify the generated app bundle with:

```bash
./scripts/build_and_run.sh --verify
```

## App Bundle

The app-bundle path is now concrete: `scripts/generate_xcode_project.py` generates `FlowDesign.xcodeproj`, which builds `FlowDesign.app` from the existing source layout. Early stack and architecture decisions are tracked in [Technical Decisions](docs/technical-decisions.md).

## Document Lifecycle

Flow Design registers `.flowdesign` as a native macOS package document type. The app shell now uses SwiftUI `DocumentGroup` for New/Open/Save, with `document.json` as the semantic source of truth inside each package and reserved `paperkit`, `previews`, and `provenance` sidecar directories managed by the core package store.

The first native semantic edit paths are the document title field, app-level text section editors, and selected-view text section editors in the sidebar. Edits route through core document commands, update document revision metadata, register with the document undo manager where the SwiftUI scene provides one, and persist through the same package save/reopen path as the rest of the semantic model.
