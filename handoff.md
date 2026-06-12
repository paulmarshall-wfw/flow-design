# Handoff

## 1. Metadata
- Project name: Flow Design
- Handoff type: active build checkpoint
- Created timestamp UTC: 2026-06-12T11:32:54Z
- Prepared by: Codex
- Repository: `/Users/paulmarshall/Software Development/flow-design`
- Branch or working context: `main`
- Session scope: Phase 0 build continuation adding selected-view text editing and document command/undo scaffolding.

### Checkpoint Status
- Git HEAD: `a6c9f28`
- Working tree: dirty
- Dirty files intentionally in scope:
  - `README.md`
  - `Sources/FlowDesignApp/FlowDesignApp.swift`
  - `Sources/FlowDesignCore/FlowDesignDocument.swift`
  - `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift`
  - `docs/completed-tasks.md`
  - `docs/technical-decisions.md`
  - `handoff.md`
- Dirty files intentionally out of scope:
  - None
- Untracked files intentionally in scope:
  - None
- Untracked files intentionally out of scope:
  - None
- Canonical files described:
  - `handoff.md`
  - `docs/completed-tasks.md`
  - `AGENTS.md`
  - `README.md`
  - `docs/technical-decisions.md`
  - `Sources/FlowDesignApp/FlowDesignApp.swift`
  - `Sources/FlowDesignCore/FlowDesignDocument.swift`
  - `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift`
- Last verification:
  - command: `swift build`; `swift test`; `python3 scripts/generate_xcode_project.py`; `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO build`; `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO test`; `./scripts/build_and_run.sh --verify`
  - result: passed; sandboxed SwiftPM was blocked by user module-cache permissions, and reruns outside the sandbox passed with 16 XCTest cases. Xcode build/test passed with 16 XCTest cases and known CoreSimulator out-of-date warnings. Native launch verification built, launched, and verified the `FlowDesign` process from the generated Debug bundle.
  - timestamp UTC: 2026-06-12T11:32:54Z
- Handoff freshness: fresh-to-dirty-tree
- Safe-to-continue basis: SwiftPM build/test pass, Xcode app build/test pass, and native launch verification confirms the app process starts from the generated Debug bundle.
- Next checkpoint action: commit this selected-view text editing and command/undo scaffolding dirty tree, or intentionally carry it as the next implementation base.

## 2. Executive Summary
Flow Design now has document title editing, editable app-level text sections, and selected-view text-section editing in the native sidebar. The sidebar exposes app text sections plus the active view's View Description and Acceptance Criteria, all routed through `FlowDesignDocument.updateTextSectionBody(sectionID:body:updatedAt:)` so document revision and timestamp metadata update consistently.

The app scene now registers title and text-section mutations with the document undo manager when available, and the Flow menu has focused document command scaffolding with selected-view command enablement. Core tests cover editing every default app-owned text section, editing default view-owned text sections, and saving/reopening those changes through the `.flowdesign` package store. The app remains in local unsigned Build Mode.

Completed work history is tracked in `docs/completed-tasks.md`; do not duplicate it here beyond this current checkpoint.

## 3. Current Objective
- Immediate goal: continue local authoring on top of native document lifecycle, title editing, app-level text editing, selected-view text editing, and document command/undo scaffolding.
- Intended finished state for the next slice: add view switching/management commands, selected app-container inspection, or the first structured flow element edit path.
- Definition of done for the next slice: SwiftPM and Xcode verification pass, automated coverage protects the new edit behavior where practical, and manual launch verification confirms the app still opens.

## 4. Current State
### Working
- SwiftPM build/test path exists through `swift build` and `swift test`.
- Xcode app-bundle path exists through generated `FlowDesign.xcodeproj`.
- `FlowDesign.app` builds from the generated Xcode project.
- Xcode test scheme runs `FlowDesignCoreTests` successfully.
- `./scripts/build_and_run.sh --verify` builds, launches, and verifies the native `FlowDesign` process.
- `Resources/Info.plist` registers `.flowdesign` package documents using UTI `com.paulmarshall.flow-design.document`.
- `FlowDesignApp` uses SwiftUI `DocumentGroup` with `FlowDesignFileDocument` for native New/Open/Save.
- The sidebar has a document title field bound to the semantic document through `FlowDesignDocument.updateTitle(_:)`.
- The sidebar has app-level text editors for App Synopsis, Major Features, Happy Path Description, and Logic Description.
- The sidebar has selected-view text editors for View Description and Acceptance Criteria.
- Text-section edits update document revision, document updated timestamp, and section updated timestamp; unchanged text does not create extra revisions.
- Title and text-section edits register undo operations with the SwiftUI document undo manager when the scene provides one.
- The Flow menu exposes a focused `Show Selected View Text` command whose enabled state follows the active document view.
- Title and text-section edits persist in `document.json` through package save/reopen.
- `FlowDesignFileDocument` declares `.flowdesign` as a package document type and bridges SwiftUI FileDocument I/O to the core package store.
- `FlowDesignCore` has a schema-versioned `Codable` semantic document model for `document.json`.
- `FlowDesignDocumentPackageStore.save(_:to:)` creates or updates a package directory and writes `document.json` atomically.
- Package save creates reserved `paperkit`, `previews`, and `provenance` directories without deleting existing sidecar files.
- FileWrapper package helpers round-trip `document.json`, preserve captured sidecar members, and create missing reserved directories for native document saves.
- XCTest covers JSON round trip, title edit metadata, text-section edit metadata, all app text-section package persistence, all selected-view text-section package persistence, unknown-section no-op behavior, unsupported schema version, URL package save/load, URL sidecar preservation, FileWrapper package save/load, FileWrapper sidecar preservation, missing `document.json`, and invalid file-as-package paths.

### Partially Working
- Native document lifecycle is present, but the app still shows a simple sidebar/canvas scaffold rather than the full-canvas workspace with floating panels from the UX docs.
- App-level and selected-view text sections can be edited, but flow elements, connections, validation records, object-owned acceptance criteria, and proposals are not user-editable yet.
- PaperKit is available behind `FlowDesignPaperKit`, but structured flow element round-tripping remains a documented strategy and no PaperKit package payload is produced yet.
- App icon assets are not final; add a reviewed icon before signed release or distribution work.

### Not Working Yet
- Undo/redo scaffolding exists for title and text-section edits, but it has not yet been expanded to canvas edits, proposal applications, or view/layout changes.
- Document-scoped command enablement exists for the selected-view text command, but view switching/creation/deletion commands are not implemented yet.
- No schema migrations beyond the current unsupported-version error path exist yet.
- No deterministic validation execution, source-linked code links, proposal application, or document snapshot lifecycle exists yet.
- No provider-backed AI runtime, task registry, prompt assets, source scanning, proposal application, or provider settings UI exists yet.
- No CI workflow exists yet.

### Not Yet Verified
- Manual save/reopen via macOS save/open panels was not interactively exercised in this run; the underlying package lifecycle is covered by core tests and app launch verification.
- Handoff freshness helper scripts do not exist, so freshness is grounded manually from Git status, HEAD, file inspection, and verification results.

## 5. Active Constraints
- Apply `AGENTS.md` project policy: Build Mode by default, numbered versions only, preserve explicit user intent, and do not commit/tag/release/publish/install/delete unless explicitly asked.
- For repo maintenance, apply the engineering-project-standard skill.
- For native app build/run/debug work, use the macOS build/run/debug workflow.
- Start product build with local authoring, semantic document modeling, persistence, and native app workflow before provider-backed AI runtime work unless the user redirects.
- `document.json` remains the semantic source of truth inside `.flowdesign` package documents.
- Flow Design is a native macOS app; core local authoring, save/reopen, deterministic validation, and export must not depend on provider availability.
- Provider calls must stay behind app-owned AI/invocation boundaries, not SwiftUI views, AppKit controllers, PaperKit adapters, or document save/load code.

## 6. Commands and Verification
- Regenerate Xcode project:
  - `python3 scripts/generate_xcode_project.py`
- SwiftPM verification:
  - `swift build`
  - `swift test`
- Xcode app-bundle build:
  - `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO build`
- Xcode app-bundle tests:
  - `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO test`
- Native launch verification:
  - `./scripts/build_and_run.sh --verify`
- Notes:
  - Xcode emits CoreSimulator warnings on this machine, but macOS build/test still pass.
  - Sandboxed SwiftPM can fail when Swift cannot write the user module cache; rerun outside the sandbox passed.
  - Sandboxed Xcode tests can fail when `testmanagerd.control` is blocked; rerun outside the sandbox passed.
  - Native launch verification requires normal macOS app-launch access and passed outside the sandbox.

## 7. Files to Open First
- `AGENTS.md`: repo commands and workflow expectations.
- `docs/technical-decisions.md`: package shape, document model, app-bundle decisions, document scene boundary, and semantic edit paths.
- `README.md`: current build/test/app-bundle and document lifecycle workflow.
- `scripts/generate_xcode_project.py`: source of truth for generated Xcode project shape.
- `scripts/build_and_run.sh`: local native build and launch verification path.
- `Resources/Info.plist`: document type and app bundle metadata.
- `docs/prd-unified-v2.md`: active product requirements.
- `docs/architecture.md`: target boundaries and provider-registry alignment.
- `Sources/FlowDesignApp/FlowDesignApp.swift`: `DocumentGroup` scene, sidebar title/app/view text-section editors, undo registration, focused Flow menu command scaffolding, and workspace binding.
- `Sources/FlowDesignApp/FlowDesignFileDocument.swift`: SwiftUI `FileDocument` wrapper for `.flowdesign` packages.
- `Sources/FlowDesignCore/FlowDesignDocument.swift`: semantic domain model, view/app text-section lookup helpers, title and text-section edit commands, and JSON boundary.
- `Sources/FlowDesignCore/FlowDesignDocumentPackageStore.swift`: URL and FileWrapper package save/load boundary.
- `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift`: semantic model, title edit, app/view text-section edit, and package persistence coverage.

## 8. Next Actions
### Next
- Commit or intentionally carry the current selected-view text editing and command/undo scaffolding dirty tree.
- Add native view switching/management commands using the same focused document command pattern.
- Add the first structured flow element authoring path or selected app-container inspection surface.

### Blocked
- None known.

### Later
- Add schema migration scaffolding when the first schema change is needed.
- Add PaperKit sidecar writing after structured flowchart editing starts.
- Add a final app icon asset before signed release/distribution work.
- Add CI once repository hosting/CI target is chosen.
- Add Codex Run-button config if `.codex` becomes writable or the user explicitly approves editing that restricted project path.
- Add `FlowDesignAI` and `FlowDesignInvokeBridge` after local authoring, persistence, validation, and proposal records are stable.

## 9. Ready-Made Prompt for Starting a New Thread
Read `handoff.md` as the hot current-state source for `/Users/paulmarshall/Software Development/flow-design`. Review `AGENTS.md`, `docs/technical-decisions.md`, `README.md`, `scripts/generate_xcode_project.py`, `scripts/build_and_run.sh`, `Resources/Info.plist`, `docs/prd-unified-v2.md`, `Sources/FlowDesignApp/FlowDesignApp.swift`, `Sources/FlowDesignApp/FlowDesignFileDocument.swift`, `Sources/FlowDesignCore/FlowDesignDocument.swift`, `Sources/FlowDesignCore/FlowDesignDocumentPackageStore.swift`, and `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift` before making changes. Treat `a6c9f28` as the committed baseline and the current dirty tree as the selected-view text editing plus command/undo scaffolding continuation. Start by committing or carrying this dirty tree, then add native view management commands, selected app-container inspection, or the first structured flow element authoring path unless the user redirects.
