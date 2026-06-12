# Handoff

## 1. Metadata
- Project name: Flow Design
- Handoff type: active build checkpoint
- Created timestamp UTC: 2026-06-12T07:48:17Z
- Prepared by: Codex
- Repository: `/Users/paulmarshall/Software Development/flow-design`
- Branch or working context: `main`
- Session scope: Phase 0 build slice adding the first user-facing text-section edit path.

### Checkpoint Status
- Git HEAD: `17af323`
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
- Last verification:
  - command: `swift build`; `swift test`; `python3 scripts/generate_xcode_project.py`; `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO build`; `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO test`; `./scripts/build_and_run.sh --verify`
  - result: passed; sandboxed `swift build`/`swift test` were blocked by user module cache permissions, sandboxed Xcode tests were blocked by `testmanagerd.control`, and sandboxed launch verification rebuilt but LaunchServices returned `kLSNoExecutableErr`; reruns outside the sandbox passed
  - timestamp UTC: 2026-06-12T07:48:17Z
- Handoff freshness: fresh-to-dirty-tree
- Safe-to-continue basis: SwiftPM build/test pass, Xcode app build/test pass, and native launch verification confirms the app process starts from the generated Debug bundle.
- Next checkpoint action: commit the title-and-synopsis-edit dirty tree, or intentionally carry it as the next implementation base.

## 2. Executive Summary
Flow Design now has two user-facing semantic edit paths on top of the native `.flowdesign` document lifecycle. The SwiftUI document scene exposes a document title field and an app synopsis editor in the sidebar. Title changes route through `FlowDesignDocument.updateTitle(_:)`; synopsis changes route through `FlowDesignDocument.updateTextSectionBody(sectionID:body:updatedAt:)`.

Core tests now cover title edits, text-section edits, unknown-section no-op behavior, and package save/reopen persistence for changed title, app synopsis, and revision metadata. The app remains in local unsigned Build Mode.

Completed work history is tracked in `docs/completed-tasks.md`; do not duplicate it here beyond this current checkpoint.

## 3. Current Objective
- Immediate goal: continue local authoring on top of native document lifecycle, title editing, and app synopsis editing.
- Intended finished state for the next slice: add document-scoped command enablement, undo/redo scaffolding, or another small text-section edit surface that marks the document dirty and persists semantic data through save/reopen.
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
- Title edits update document revision and timestamp metadata, and persist in `document.json` through package save/reopen.
- The sidebar has an app synopsis text editor bound to the default app-owned text section through `FlowDesignDocument.updateTextSectionBody(sectionID:body:updatedAt:)`.
- Text-section body edits update document revision, document updated timestamp, and section updated timestamp; unchanged text does not create extra revisions.
- `FlowDesignFileDocument` declares `.flowdesign` as a package document type and bridges SwiftUI FileDocument I/O to the core package store.
- `FlowDesignCore` has a schema-versioned `Codable` semantic document model for `document.json`.
- `FlowDesignDocumentPackageStore.save(_:to:)` creates or updates a package directory and writes `document.json` atomically.
- Package save creates reserved `paperkit`, `previews`, and `provenance` directories without deleting existing sidecar files.
- FileWrapper package helpers round-trip `document.json`, preserve captured sidecar members, and create missing reserved directories for native document saves.
- XCTest covers JSON round trip, title edit metadata, text-section edit metadata, unknown text-section no-op behavior, unsupported schema version, URL package save/load, URL sidecar preservation, FileWrapper package save/load, FileWrapper sidecar preservation, missing `document.json`, and invalid file-as-package paths.

### Partially Working
- Native document lifecycle is present, but the app still shows a simple sidebar/canvas scaffold rather than the full-canvas workspace with floating panels from the UX docs.
- The document title and app synopsis can be edited, but the remaining app text sections, view text sections, flow elements, connections, validation records, and proposals are not user-editable yet.
- PaperKit is available behind `FlowDesignPaperKit`, but structured flow element round-tripping remains a documented strategy and no PaperKit package payload is produced yet.
- App icon assets are not final; add a reviewed icon before signed release or distribution work.

### Not Working Yet
- No user-facing edit path exists yet for major features, happy path description, logic description, view descriptions, or acceptance criteria.
- No autosave policy, explicit undo/redo integration, or document-scoped command enablement exists yet.
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
  - Sandboxed native launch verification can report LaunchServices `kLSNoExecutableErr`; rerun outside the sandbox passed and verified the `FlowDesign` process.

## 7. Files to Open First
- `AGENTS.md`: repo commands and workflow expectations.
- `docs/technical-decisions.md`: package shape, document model, app-bundle decisions, document scene boundary, and first semantic edit paths.
- `README.md`: current build/test/app-bundle and document lifecycle workflow.
- `scripts/generate_xcode_project.py`: source of truth for generated Xcode project shape.
- `scripts/build_and_run.sh`: local native build and launch verification path.
- `Resources/Info.plist`: document type and app bundle metadata.
- `docs/prd-unified-v2.md`: active product requirements.
- `docs/architecture.md`: target boundaries and provider-registry alignment.
- `Sources/FlowDesignApp/FlowDesignApp.swift`: `DocumentGroup` scene, sidebar title and app synopsis editors, and workspace binding.
- `Sources/FlowDesignApp/FlowDesignFileDocument.swift`: SwiftUI `FileDocument` wrapper for `.flowdesign` packages.
- `Sources/FlowDesignCore/FlowDesignDocument.swift`: semantic domain model, title and text-section edit commands, and JSON boundary.
- `Sources/FlowDesignCore/FlowDesignDocumentPackageStore.swift`: URL and FileWrapper package save/load boundary.
- `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift`: semantic model, title edit, text-section edit, and package persistence coverage.

## 8. Next Actions
### Next
- Commit or intentionally carry the current title-and-synopsis-edit dirty tree.
- Add document-scoped command enablement and undo/redo scaffolding for the existing semantic mutation paths.
- Add another small text-section edit surface, preferably remaining app-level sections or the selected view description, using the existing core text-section command.

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
Read `handoff.md` as the hot current-state source for `/Users/paulmarshall/Software Development/flow-design`. Review `AGENTS.md`, `docs/technical-decisions.md`, `README.md`, `scripts/generate_xcode_project.py`, `scripts/build_and_run.sh`, `Resources/Info.plist`, `docs/prd-unified-v2.md`, `Sources/FlowDesignApp/FlowDesignApp.swift`, `Sources/FlowDesignApp/FlowDesignFileDocument.swift`, `Sources/FlowDesignCore/FlowDesignDocument.swift`, `Sources/FlowDesignCore/FlowDesignDocumentPackageStore.swift`, and `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift` before making changes. Treat `17af323` as the committed baseline and the current dirty tree as the semantic title plus app synopsis edit continuation. Start by committing or carrying this dirty tree, then add document-scoped command enablement/undo scaffolding or another small text-section edit surface unless the user redirects.
