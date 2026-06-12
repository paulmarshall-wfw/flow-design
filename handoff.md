# Handoff

## 1. Metadata
- Project name: Flow Design
- Handoff type: session end
- Created timestamp UTC: 2026-06-12T06:56:08Z
- Prepared by: Codex
- Repository: `/Users/paulmarshall/Software Development/flow-design`
- Branch or working context: `main`
- Session scope: continuity refresh after generated Xcode app-bundle path, early technical decisions, and the first Phase 0 semantic document-model slice were added.

### Checkpoint Status
- Git HEAD: `1030588`
- Working tree: dirty
- Dirty files intentionally in scope:
  - `AGENTS.md`
  - `README.md`
  - `Sources/FlowDesignCore/FlowDesignDocument.swift`
  - `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift`
  - `docs/completed-tasks.md`
  - `handoff.md`
  - `scripts/README.md`
- Dirty files intentionally out of scope:
  - None
- Untracked files intentionally in scope:
  - `FlowDesign.xcodeproj/`
  - `Resources/Assets.xcassets/Contents.json`
  - `Resources/FlowDesign.entitlements`
  - `Resources/Info.plist`
  - `docs/technical-decisions.md`
  - `scripts/build_and_run.sh`
  - `scripts/generate_xcode_project.py`
- Untracked files intentionally out of scope:
  - None
- Canonical files described:
  - `AGENTS.md`
  - `README.md`
  - `Package.swift`
  - `FlowDesign.xcodeproj/project.pbxproj`
  - `FlowDesign.xcodeproj/xcshareddata/xcschemes/FlowDesign.xcscheme`
  - `Resources/Info.plist`
  - `Resources/FlowDesign.entitlements`
  - `Resources/Assets.xcassets/Contents.json`
  - `docs/technical-decisions.md`
  - `docs/prd-unified-v2.md`
  - `docs/architecture.md`
  - `docs/product-fundamentals.md`
  - `docs/ux-design.md`
  - `docs/completed-tasks.md`
  - `handoff.md`
- Last verification:
  - command: `swift build`; `swift test`; `python3 scripts/generate_xcode_project.py`; `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO build`; `xcodebuild ... test`; `./scripts/build_and_run.sh --verify`
  - result: passed
  - timestamp UTC: 2026-06-12T06:56:08Z
- Handoff freshness: fresh-to-dirty-tree
- Safe-to-continue basis: current `HEAD` is known, all dirty/untracked files are intentional app-bundle baseline and Phase 0 semantic-model work, and SwiftPM plus generated Xcode build/test/launch verification passed.
- Next checkpoint action: commit the app-bundle path plus semantic-model slice, or intentionally leave this dirty tree as the next implementation base.

## 2. Executive Summary
Flow Design now has a concrete native app-bundle path and the first Phase 0 semantic document model. The repo keeps its SwiftPM-friendly `Sources/` and `Tests/` layout, while `scripts/generate_xcode_project.py` generates `FlowDesign.xcodeproj` for the macOS app target.

The core document model now stores schema version `0.1.0`, lifecycle state, app container ID, flow views, flow containers, flow elements, connections, text sections, acceptance criteria, code links, validation findings, proposals, and provenance records as `Codable` `FlowDesignCore` types. `FlowDesignDocument.encodedDocumentJSON()` and `FlowDesignDocument.decodeDocumentJSON(from:)` are the first package-ready JSON boundary for future `document.json` save/reopen work.

The early stack gaps are explicitly addressed in `docs/technical-decisions.md`: app bundle generation, signing/entitlements/document type/assets, document package persistence, schema versioning, PaperKit round-trip strategy, UI architecture, CI/static analysis, launch verification, and AI bridge lifecycle.

Completed work history is tracked in `docs/completed-tasks.md`; do not duplicate it here. No `project-dossier.md` exists or was needed for this update.

## 3. Current Objective
- Immediate goal: begin the next Phase 0 local-authoring implementation slice on top of the generated Xcode app-bundle and semantic-model baseline.
- Intended finished state: document package save/reopen support that persists semantic JSON as `document.json` while keeping room for PaperKit package members.
- Definition of done for the next slice: SwiftPM and Xcode verification pass, package save/reopen behavior has automated tests, and stable IDs survive JSON/package round trip.

## 4. Current State
### Working
- SwiftPM build/test path exists through `swift build` and `swift test`.
- Xcode app-bundle path exists through generated `FlowDesign.xcodeproj`.
- `FlowDesign.app` builds from the generated Xcode project.
- Xcode test scheme runs `FlowDesignCoreTests` successfully when outside the workspace sandbox.
- Xcode static analysis passes for the generated scheme.
- `./scripts/build_and_run.sh --verify` builds, launches, and verifies the native `FlowDesign` process.
- `Resources/Info.plist` registers `.flowdesign` package documents using UTI `com.paulmarshall.flow-design.document`.
- `Resources/FlowDesign.entitlements` exists and is intentionally empty for unsigned local Build Mode.
- `Resources/Assets.xcassets/Contents.json` exists as the tracked asset-catalog root.
- `FlowDesignCore` has a schema-versioned `Codable` semantic document model for `document.json`.
- New untitled documents create the canonical app container, four initial flow views, app-level text sections, and view-level text sections.
- JSON encode/decode round trip and unsupported schema-version behavior are covered by XCTest.

### Partially Working
- The app still shows the existing simple SwiftUI scaffold; it is not yet the full-canvas workspace from the UX docs.
- `FlowDesignCore` now models the semantic flow graph and JSON boundary, but package read/write, migrations, validation rules, and document-scoped commands are not implemented yet.
- PaperKit is available behind `FlowDesignPaperKit`, but structured flow element round-tripping is only a documented strategy.
- App icon assets are not final; add a reviewed icon before signed release or distribution work.

### Not Working Yet
- No document package save/reopen lifecycle exists yet.
- No schema migrations, deterministic validation execution, source-linked code links, proposal application, or document snapshot lifecycle exists yet.
- No provider-backed AI runtime, task registry, prompt assets, source scanning, proposal application, or provider settings UI exists yet.
- No CI workflow exists yet.
- Optional Codex Run-button config was not created because `.codex` is read-only in this workspace.

### Not Yet Verified
- Handoff freshness helper scripts do not exist, so freshness is grounded manually from Git status and file existence.

## 5. Active Constraints
- Apply `AGENTS.md` project policy: Build Mode by default, numbered versions only, preserve explicit user intent, and do not commit/tag/release/publish/install/delete unless explicitly asked.
- For repo maintenance, apply the engineering-project-standard skill.
- For native app build/run/debug work, use the macOS build/run/debug workflow.
- Start product build with local authoring, semantic document modeling, persistence, and native app workflow before provider-backed AI runtime work unless the user redirects.
- `docs/technical-decisions.md` now owns the early technical decisions that were previously open.
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
- Static analysis:
  - `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO analyze`
- Native launch verification:
  - `./scripts/build_and_run.sh --verify`
- Notes:
  - Xcode emits CoreSimulator warnings on this machine, but macOS build/test/analyze still pass.
  - Sandboxed `xcodebuild test` failed when it could not talk to Apple test runner services; rerun outside the sandbox passed.
  - Sandboxed `swift build` and `swift test` can fail when Swift cannot write the user module cache; rerun outside the sandbox passed.

## 7. Files to Open First
- `AGENTS.md`: updated repo commands and current workflow expectations.
- `docs/technical-decisions.md`: early stack decisions and implementation boundaries.
- `README.md`: current build/test/app-bundle workflow.
- `scripts/generate_xcode_project.py`: source of truth for generated Xcode project shape.
- `scripts/build_and_run.sh`: local native build and launch verification path.
- `Resources/Info.plist`: document type and app bundle metadata.
- `docs/prd-unified-v2.md`: active product requirements.
- `docs/architecture.md`: target boundaries and provider-registry alignment.
- `Sources/FlowDesignCore/FlowDesignDocument.swift`: current semantic domain model and JSON boundary.
- `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift`: current semantic model and JSON round-trip coverage.

## 8. Next Actions
### Next
- Commit or intentionally carry the app-bundle path, technical-decision files, and semantic-model slice.
- Add document package save/reopen support using `document.json` as the semantic source of truth.
- Add migration/error handling structure around schema version `0.1.0` before the schema evolves.

### Blocked
- None known.

### Later
- Add a final app icon asset before signed release/distribution work.
- Add CI once repository hosting/CI target is chosen.
- Add Codex Run-button config if `.codex` becomes writable or the user explicitly approves editing that restricted project path.
- Add `FlowDesignAI` and `FlowDesignInvokeBridge` after local authoring, persistence, validation, and proposal records are stable.

## 9. Ready-Made Prompt for Starting a New Thread
Read `handoff.md` as the hot current-state source for `/Users/paulmarshall/Software Development/flow-design`. Review `AGENTS.md`, `docs/technical-decisions.md`, `README.md`, `scripts/generate_xcode_project.py`, `scripts/build_and_run.sh`, `Resources/Info.plist`, `docs/prd-unified-v2.md`, `Sources/FlowDesignCore/FlowDesignDocument.swift`, and `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift` before making changes. Treat `1030588` as the committed baseline and the current dirty tree as the generated Xcode app-bundle/technical-decisions plus Phase 0 semantic-model work. Start with document package save/reopen support unless the user redirects.
