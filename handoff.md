# Handoff

## 1. Metadata
- Project name: Flow Design
- Handoff type: session end
- Created timestamp UTC: 2026-06-12T07:11:33Z
- Prepared by: Codex
- Repository: `/Users/paulmarshall/Software Development/flow-design`
- Branch or working context: `main`
- Session scope: next Phase 0 build slice adding native document package save/reopen support on top of the schema-versioned semantic model.

### Checkpoint Status
- Git HEAD: `6a1ea94`
- Working tree: dirty
- Dirty files intentionally in scope:
  - `FlowDesign.xcodeproj/project.pbxproj`
  - `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift`
  - `docs/completed-tasks.md`
  - `handoff.md`
  - `scripts/generate_xcode_project.py`
- Dirty files intentionally out of scope:
  - None
- Untracked files intentionally in scope:
  - `Sources/FlowDesignCore/FlowDesignDocumentPackageStore.swift`
- Untracked files intentionally out of scope:
  - None
- Canonical files described:
  - `AGENTS.md`
  - `README.md`
  - `Package.swift`
  - `FlowDesign.xcodeproj/project.pbxproj`
  - `docs/technical-decisions.md`
  - `docs/completed-tasks.md`
  - `handoff.md`
  - `scripts/generate_xcode_project.py`
  - `scripts/build_and_run.sh`
  - `Sources/FlowDesignCore/FlowDesignDocument.swift`
  - `Sources/FlowDesignCore/FlowDesignDocumentPackageStore.swift`
  - `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift`
- Last verification:
  - command: `swift build`; `swift test`; `python3 scripts/generate_xcode_project.py`; `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO build`; `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO test`; `./scripts/build_and_run.sh --verify`
  - result: passed
  - timestamp UTC: 2026-06-12T07:11:33Z
- Handoff freshness: fresh-to-dirty-tree
- Safe-to-continue basis: package persistence has core tests, SwiftPM verification passes, the generated Xcode app-bundle path includes the new core source, Xcode build/test pass, and the native app launches.
- Next checkpoint action: commit the semantic-model plus package-persistence dirty tree, or intentionally carry it as the next implementation base.

## 2. Executive Summary
Flow Design now has the first native document package persistence boundary. `FlowDesignDocumentPackageStore` saves semantic documents into `.flowdesign` package directories using `document.json` as the source of truth, creates the reserved `paperkit`, `previews`, and `provenance` directories, reloads documents through the schema-versioned decoder, preserves existing sidecar files, and returns explicit errors for missing `document.json` or file paths used as package directories.

The app remains in local unsigned Build Mode. The SwiftUI shell still uses an in-memory untitled document; the new persistence code is core-layer infrastructure ready for the next slice that wires native open/save document lifecycle into the app.

Completed work history is tracked in `docs/completed-tasks.md`; do not duplicate older entries here. No `project-dossier.md` exists.

## 3. Current Objective
- Immediate goal: wire the core package store into native app document lifecycle.
- Intended finished state: users can create, save, reopen, and edit `.flowdesign` package documents through the macOS app shell while semantic IDs survive round trips.
- Definition of done for the next slice: SwiftPM and Xcode verification pass, app-level document lifecycle has automated coverage where practical, and manual launch verification confirms the app still opens.

## 4. Current State
### Working
- SwiftPM build/test path exists through `swift build` and `swift test`.
- Xcode app-bundle path exists through generated `FlowDesign.xcodeproj`.
- `FlowDesign.app` builds from the generated Xcode project.
- Xcode test scheme runs `FlowDesignCoreTests` successfully.
- `./scripts/build_and_run.sh --verify` builds, launches, and verifies the native `FlowDesign` process.
- `Resources/Info.plist` registers `.flowdesign` package documents using UTI `com.paulmarshall.flow-design.document`.
- `FlowDesignCore` has a schema-versioned `Codable` semantic document model for `document.json`.
- `FlowDesignDocumentPackageStore.save(_:to:)` creates or updates a package directory and writes `document.json` atomically.
- Package save creates reserved `paperkit`, `previews`, and `provenance` directories without deleting existing sidecar files.
- `FlowDesignDocumentPackageStore.load(from:)` reloads through `FlowDesignDocument.decodeDocumentJSON(from:)`, so unsupported schema handling remains centralized.
- XCTest covers JSON round trip, unsupported schema version, package save/load, sidecar preservation, missing `document.json`, and invalid file-as-package paths.

### Partially Working
- The app still shows the existing simple SwiftUI scaffold; it is not yet the full-canvas workspace from the UX docs.
- Persistence is implemented in core, but not yet wired to `DocumentGroup`, `FileDocument`, menu commands, autosave, undo, or app window state.
- PaperKit is available behind `FlowDesignPaperKit`, but structured flow element round-tripping remains a documented strategy and no PaperKit package payload is produced yet.
- App icon assets are not final; add a reviewed icon before signed release or distribution work.

### Not Working Yet
- No user-facing document package open/save lifecycle exists in the app shell yet.
- No schema migrations beyond the current unsupported-version error path exist yet.
- No deterministic validation execution, source-linked code links, proposal application, or document snapshot lifecycle exists yet.
- No provider-backed AI runtime, task registry, prompt assets, source scanning, proposal application, or provider settings UI exists yet.
- No CI workflow exists yet.
- Optional Codex Run-button config was not created because `.codex` is read-only in this workspace.

### Not Yet Verified
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

## 7. Files to Open First
- `AGENTS.md`: repo commands and workflow expectations.
- `docs/technical-decisions.md`: package shape, document model, and app-bundle decisions.
- `README.md`: current build/test/app-bundle workflow.
- `scripts/generate_xcode_project.py`: source of truth for generated Xcode project shape.
- `scripts/build_and_run.sh`: local native build and launch verification path.
- `Resources/Info.plist`: document type and app bundle metadata.
- `docs/prd-unified-v2.md`: active product requirements.
- `docs/architecture.md`: target boundaries and provider-registry alignment.
- `Sources/FlowDesignCore/FlowDesignDocument.swift`: semantic domain model and JSON boundary.
- `Sources/FlowDesignCore/FlowDesignDocumentPackageStore.swift`: package save/load boundary.
- `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift`: semantic model and package persistence coverage.

## 8. Next Actions
### Next
- Commit or intentionally carry the current app-bundle, semantic-model, and package-persistence dirty tree.
- Add app-level document lifecycle using the package store, likely through a native `FileDocument`/`DocumentGroup` boundary if it fits package documents cleanly.
- Add document-scoped commands for new/open/save once persistence is wired into app state.

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
Read `handoff.md` as the hot current-state source for `/Users/paulmarshall/Software Development/flow-design`. Review `AGENTS.md`, `docs/technical-decisions.md`, `README.md`, `scripts/generate_xcode_project.py`, `scripts/build_and_run.sh`, `Resources/Info.plist`, `docs/prd-unified-v2.md`, `Sources/FlowDesignCore/FlowDesignDocument.swift`, `Sources/FlowDesignCore/FlowDesignDocumentPackageStore.swift`, and `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift` before making changes. Treat `6a1ea94` as the committed baseline and the current dirty tree as the package-persistence continuation on top of the generated Xcode app-bundle and semantic-model work. Start by wiring package persistence into native app document lifecycle unless the user redirects.
