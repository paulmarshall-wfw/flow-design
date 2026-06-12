# Technical Decisions

This file records early implementation decisions that should be settled before product build work expands. Keep it concise and update it when a decision changes.

## App Bundle Path

- Decision: keep the SwiftPM-friendly `Sources/` and `Tests/` layout, and generate a real Xcode app project from tracked repo inputs.
- Generator: `scripts/generate_xcode_project.py`.
- Generated project: `FlowDesign.xcodeproj`.
- App scheme: `FlowDesign`.
- Build output: `.build/XcodeDerivedData/Build/Products/Debug/FlowDesign.app`.
- Rationale: Xcode owns macOS app-bundle details while SwiftPM remains useful for fast core build/test loops.

## Signing, Entitlements, Document Types, Icons, And Assets

- Build Mode uses unsigned local debug builds with `CODE_SIGNING_ALLOWED=NO`.
- Entitlements are tracked at `Resources/FlowDesign.entitlements`; they are intentionally empty until sandbox, file access, or distribution requirements are explicit.
- Document type is registered in `Resources/Info.plist`:
  - UTI: `com.paulmarshall.flow-design.document`
  - Extension: `.flowdesign`
  - Role: editor
  - Conforms to: `com.apple.package`
- Asset catalog is tracked at `Resources/Assets.xcassets`.
- App icon assets are not final yet. Add a numbered, reviewable icon asset before any distribution or signed release path.

## Persistence And Document Package Shape

- Decision: Flow Design documents are native package documents.
- Source of truth: semantic JSON in `document.json`.
- Package members:
  - `document.json`: canonical semantic model and schema version.
  - `paperkit/`: PaperKit rendering or interaction data keyed by flow view or canvas ID.
  - `previews/`: optional generated previews.
  - `provenance/`: optional generation records, source scans, and task-run summaries.
- Save/reopen must preserve semantic IDs, flow views, layout, text sections, connections, validation state, and proposal records.
- If semantic JSON and PaperKit data disagree, semantic JSON wins and PaperKit data is marked stale or regenerated.
- The app uses SwiftUI `DocumentGroup` with a `FileDocument` wrapper for native New/Open/Save handling of `.flowdesign` package documents.
- `FlowDesignDocumentPackageStore` owns both URL-based package persistence and FileWrapper-based package read/write helpers so app document lifecycle code does not duplicate package shape rules.
- FileWrapper saves replace `document.json`, ensure reserved package directories exist, and carry forward sidecar package members captured during open.

## Serialization And Schema Versioning

- Decision: use Codable Swift types in `FlowDesignCore` for `document.json`.
- Every persisted document stores a numbered `schemaVersion` string.
- Start schema version: `0.1.0`.
- Schema changes require explicit migration code or a documented unsupported-version error.
- Stable IDs must not be regenerated during normal save/reopen.
- UI labels may change, but persisted enum cases and JSON keys must remain stable or migrate deliberately.

## PaperKit Round Trip Strategy

- Decision: PaperKit is the native interaction/rendering layer, not the durable source of flow meaning.
- `FlowDesignPaperKit` owns all PaperKit symbols and conversion code.
- First implementation should render structured semantic flow elements into PaperKit-backed views.
- PaperKit data may cache layout and interaction details by view, but semantic element, connection, text, and provenance records stay in `document.json`.
- Freehand PaperKit interpretation is out of scope until structured flowchart editing works.
- If PaperKit cannot support structured selection, hit testing, undo, or restoration well enough, switch the canvas implementation to a custom SwiftUI/AppKit canvas without changing the semantic package model.

## UI Architecture

- `FlowDesignApp` owns window, scene, native commands, toolbar, panel visibility, and document lifecycle.
- `FlowDesignApp` presents `.flowdesign` documents through `DocumentGroup`; document scene state such as selected canvas is window-scoped, while semantic document data remains inside the bound file document.
- `FlowDesignCore` owns document, schema, validation, proposal, provenance, and persistence-safe types with no UI framework dependencies.
- `FlowDesignPaperKit` owns PaperKit/AppKit/SwiftUI bridge code.
- The main workspace is a full-canvas SwiftUI surface with floating Inspector and Text panels.
- Inspector state is selection-driven and mode-aware.
- Text panel state is sticky and document-owned.
- Undo/redo should be document-scoped and cover semantic edits, text edits, proposal applications, and view/layout changes.
- SwiftUI views must call application services or model commands; they must not mutate provider outputs, package files, or PaperKit data directly.

## CI, Lint, And Static Analysis

- Root verification remains:
  - `swift build`
  - `swift test`
- Xcode app-bundle verification is:
  - `python3 scripts/generate_xcode_project.py`
  - `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO build`
  - `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO test`
- Static analysis should use `xcodebuild analyze` once the generated project remains stable.
- A dedicated formatter or linter is not selected yet. Prefer Apple `swift-format` only if it is available or deliberately added as a pinned tool.
- CI should run SwiftPM build/test and Xcode build/test before merge once remote CI exists.

## Native App Launch Verification

- Local launch command: `./scripts/build_and_run.sh --verify`.
- The script regenerates the Xcode project, builds the Debug app bundle, launches it with `open -n`, and verifies a `FlowDesign` process is running.
- Launch verification is local-only and not a distribution or release process.

## AI Bridge Transport And Lifecycle

- Decision: defer provider-backed AI until local authoring, persistence, validation, and proposal records are stable.
- Initial bridge transport: short-lived local Node command over JSON stdin/stdout.
- Upgrade to a long-lived IPC helper only if startup cost or streaming UX requires it.
- `FlowDesignAI` owns task definitions, prompt versions, context construction, structured schemas, readiness checks, and proposal conversion.
- `FlowDesignInvokeBridge` owns calls to `@invoke-providers/client`, `@invoke-providers/core`, and `@invoke-providers/adapters`.
- Bridge lifecycle:
  - Flow Design builds bounded task input from semantic JSON and approved source context.
  - The bridge resolves provider metadata through the shared registry and invokes the task.
  - The bridge returns validated JSON records only.
  - Flow Design stores task-run provenance and presents proposals, findings, source-impact records, or explanations for review.
  - Accepted changes apply through normal document commands and undo/redo.
- Provider SDKs must not be called directly from SwiftUI views, AppKit controllers, PaperKit adapters, document save/load code, or semantic model types.
