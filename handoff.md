# Handoff

## 1. Metadata
- Project name: Flow Design
- Handoff type: session end
- Created timestamp UTC: 2026-06-12T06:29:59Z
- Prepared by: Codex
- Repository: `/Users/paulmarshall/Software Development/flow-design`
- Branch or working context: `main`
- Session scope: continuity refresh after pre-build readiness assessment and SwiftPM verification.

### Checkpoint Status
- Git HEAD: `d674fbf`
- Working tree: dirty
- Dirty files intentionally in scope:
  - `docs/completed-tasks.md`
  - `handoff.md`
- Dirty files intentionally out of scope:
  - None
- Untracked files intentionally in scope:
  - None
- Untracked files intentionally out of scope:
  - None
- Canonical files described:
  - `AGENTS.md`
  - `README.md`
  - `Package.swift`
  - `Sources/FlowDesignCore/FlowDesignDocument.swift`
  - `Sources/FlowDesignApp/FlowDesignApp.swift`
  - `Sources/FlowDesignPaperKit/PaperMarkupHost.swift`
  - `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift`
  - `docs/architecture.md`
  - `docs/prd-unified-v2.md`
  - `docs/product-fundamentals.md`
  - `docs/ux-design.md`
  - `docs/completed-tasks.md`
  - `handoff.md`
- Last verification:
  - command: `swift build`; `swift test`; `git diff --check`
  - result: passed
  - timestamp UTC: 2026-06-12T06:31:26Z
- Handoff freshness: fresh-to-dirty-tree
- Safe-to-continue basis: current `HEAD` is verified by `swift build` and `swift test`; the only expected dirty files are the requested continuity artifacts.
- Next checkpoint action: commit or intentionally leave `docs/completed-tasks.md` and `handoff.md` dirty.

## 2. Executive Summary
Flow Design is a native macOS document app scaffold for PaperKit-backed flow/canvas design. The current focus is choosing and implementing the first Phase 0 local-authoring product slice.

The provider-registry alignment docs are complete, and the SwiftPM scaffold currently builds and tests at `d674fbf`. Completed work history is tracked in `docs/completed-tasks.md`; do not duplicate it here.

The current checkout is safe to continue from as a dirty-tree continuity checkpoint. No `project-dossier.md` exists or was needed for this update.

## 3. Current Objective
- Immediate goal: start the first product build with a narrow Phase 0 local-authoring slice.
- Intended finished state: Flow Design has a concrete native app path, semantic document model, persistence format, and initial canvas/editing behavior aligned with the active PRD.
- Definition of done for the next implementation slice: build/test pass and the slice has tests for the core model or persistence behavior it introduces.

## 4. Current State
### Working
- The active PRD is `docs/prd-unified-v2.md`; README now points to it.
- Architecture docs define `FlowDesignAI` and `FlowDesignInvokeBridge` as future boundaries for provider-backed AI.
- Product and UX docs require native, document-centered provider readiness and explicit user review before generated changes mutate the document.
- SwiftPM build and test pass with `swift build` and `swift test`.

### Partially Working
- The Swift package scaffold exists with `FlowDesignApp`, `FlowDesignCore`, and `FlowDesignPaperKit`.
- `FlowDesignCore` currently models only a document title and canvases; it does not yet model the semantic flow graph required by the PRD.
- `FlowDesignApp` currently uses a simple `NavigationSplitView` scaffold, not the full-canvas workspace with floating Inspector and Text panels.
- `FlowDesignPaperKit` wraps `PaperMarkupViewController` for a canvas-sized markup host, but semantic flow element round-tripping is not defined.
- AI/provider integration is documented only; no `FlowDesignAI` or `FlowDesignInvokeBridge` targets exist yet.

### Not Working Yet
- No app-bundle launch path exists.
- No Xcode project or project-generation path exists for bundle settings, signing, entitlements, document types, icons, or asset catalogs.
- No document package persistence, save/reopen lifecycle, semantic JSON export, app container, flow views, flow elements, connections, text-section ownership, validation model, or proposal model exists yet.
- No provider-backed AI runtime, task registry, prompt assets, source scanning, proposal application, or provider settings UI exists yet.

### Not Yet Verified
- No repo-local `scripts/handoff_status.py` or `scripts/verify_handoff_freshness.py` exists, so handoff freshness is grounded manually from Git status and file existence.
- No native app-bundle launch has been verified because no app-bundle launch path exists yet.

## 5. Active Constraints
- Apply `AGENTS.md` project policy: Build Mode by default, numbered versions only, preserve explicit user intent, and do not commit/tag/release/publish/install/delete unless explicitly asked.
- For repo maintenance, apply the engineering-project-standard skill.
- For browser automation, use Chrome unless the user explicitly asks otherwise.
- Flow Design is a native macOS app; core local authoring, save/reopen, deterministic validation, and export must not depend on provider availability.
- Start the product build with local authoring, semantic document modeling, persistence, and native app workflow before provider-backed AI runtime work unless the user redirects.
- The shared provider registry is catalog-only: profiles, provider configs, capabilities, health/readiness metadata, endpoint/model metadata, enabled state, and secret references only.
- Flow Design owns documents, semantic JSON, prompts, task definitions, proposals, task-run history, provenance, scan snapshots, review findings, change-impact records, and lifecycle state.
- Provider calls must stay behind app-owned AI/invocation boundaries, not SwiftUI views, AppKit controllers, PaperKit adapters, or document save/load code.

## 6. Commands and Verification
- Current root verification path:
  - `swift build`
  - `swift test`
- Continuity/docs check:
  - `git diff --check`
- Last verified:
  - `swift build` passed.
  - `swift test` passed with 1 XCTest.
  - Initial sandboxed Swift attempts failed because Swift could not write its normal user module cache; the approved local run passed.
- Not run:
  - Native app-bundle launch validation.
  - Handoff freshness helper scripts, because this repo does not have `scripts/handoff_status.py` or `scripts/verify_handoff_freshness.py`.

## 7. Files to Open First
- `AGENTS.md`: repo rules and verification commands.
- `handoff.md`: hot current-state checkpoint.
- `docs/completed-tasks.md`: concise completed-work ledger.
- `docs/prd-unified-v2.md`: active product requirements source of truth.
- `docs/architecture.md`: implementation boundary and provider-registry alignment guidance.
- `docs/product-fundamentals.md`: first usable product shape and document package direction.
- `docs/ux-design.md`: full-canvas workspace, Inspector, Text panel, and mode behavior.
- `Package.swift`: current SwiftPM targets and verification shape.
- `Sources/FlowDesignCore/FlowDesignDocument.swift`: current domain model starting point.

## 8. Next Actions
### Next
- Decide whether to commit the updated continuity files.
- Choose the first Phase 0 local-authoring implementation slice; recommended start is semantic document model plus Codable package-ready JSON types and tests.
- Decide the app-bundle path before native launch work: Xcode project, generated project, or SwiftPM executable-only for the next slice.

### Blocked
- None known.

### Later
- Add app-bundle build/launch verification once the Xcode project or project-generation path exists.
- Add document package save/reopen tests once persistence types exist.
- Add repo-local handoff helper scripts if this repo will maintain handoffs regularly.
- Add `FlowDesignAI` and `FlowDesignInvokeBridge` only after the local authoring loop has a stable semantic model and review/proposal records.

## 9. Ready-Made Prompt for Starting a New Thread
Read `handoff.md` as the hot current-state source for `/Users/paulmarshall/Software Development/flow-design`. Review `AGENTS.md`, `docs/prd-unified-v2.md`, `docs/architecture.md`, `docs/product-fundamentals.md`, `docs/ux-design.md`, `Package.swift`, and `Sources/FlowDesignCore/FlowDesignDocument.swift` before making changes. Treat `d674fbf` as the verified SwiftPM checkpoint, keep AI/provider work behind future app-owned boundaries, and start with the first Phase 0 local-authoring slice unless the user redirects.
