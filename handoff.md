# Handoff

## 1. Metadata
- Project name: Flow Design
- Handoff type: session end
- Created timestamp UTC: 2026-06-12T03:28:21Z
- Prepared by: Codex
- Repository: `/Users/paulmarshall/Software Development/flow-design`
- Branch or working context: `main`
- Session scope: continuity update after provider-registry alignment docs were committed.

### Checkpoint Status
- Git HEAD: `8ea0236`
- Working tree: dirty
- Dirty files intentionally in scope:
  - None
- Dirty files intentionally out of scope:
  - None
- Untracked files intentionally in scope:
  - `docs/completed-tasks.md`
  - `handoff.md`
- Untracked files intentionally out of scope:
  - None
- Canonical files described:
  - `README.md`
  - `docs/architecture.md`
  - `docs/prd-unified-v2.md`
  - `docs/product-fundamentals.md`
  - `docs/ux-design.md`
  - `docs/review/flow-design-provider-registry-alignment.md`
  - `docs/completed-tasks.md`
  - `handoff.md`
- Last verification:
  - command: `git diff --check`; `git diff --no-index --check /dev/null docs/completed-tasks.md`; `git diff --no-index --check /dev/null handoff.md`
  - result: passed
  - timestamp UTC: 2026-06-12T03:29:42Z
- Handoff freshness: fresh-to-dirty-tree
- Safe-to-continue basis: current `HEAD` is the committed provider-registry alignment checkpoint, and the only expected new dirty state is the requested continuity files.
- Next checkpoint action: review and either commit or leave the two continuity files intentionally dirty.

## 2. Executive Summary
Flow Design is a native macOS document app scaffold for PaperKit-backed flow/canvas design. The current focus is provider-registry alignment for future AI features.

The provider-registry alignment docs are complete and committed at `8ea0236`. Completed work history is tracked in `docs/completed-tasks.md`; do not duplicate it here.

The current checkout is safe to continue from as a dirty-tree continuity checkpoint once the new continuity files are accepted. No `project-dossier.md` exists or was needed for this update.

## 3. Current Objective
- Immediate goal: keep repo continuity current after the provider-registry alignment documentation update.
- Intended finished state: `docs/completed-tasks.md` records the completed docs pass and `handoff.md` describes the current checkpoint for a fresh session.
- Definition of done: continuity files exist, match current Git facts, and pass whitespace validation.

## 4. Current State
### Working
- The active PRD is `docs/prd-unified-v2.md`; README now points to it.
- Architecture docs define `FlowDesignAI` and `FlowDesignInvokeBridge` as future boundaries for provider-backed AI.
- Product and UX docs require native, document-centered provider readiness and explicit user review before generated changes mutate the document.
- Build and test commands remain `swift build` and `swift test`.

### Partially Working
- The Swift package scaffold exists with `FlowDesignApp`, `FlowDesignCore`, and `FlowDesignPaperKit`.
- AI/provider integration is documented only; no `FlowDesignAI` or `FlowDesignInvokeBridge` targets exist yet.

### Not Working Yet
- No app-bundle launch path exists.
- No provider-backed AI runtime, task registry, prompt assets, source scanning, proposal application, or provider settings UI exists yet.

### Not Yet Verified
- Swift build/test were not rerun for the documentation-only provider-registry alignment pass.
- No repo-local `scripts/handoff_status.py` or `scripts/verify_handoff_freshness.py` exists, so handoff freshness is grounded manually from Git status and file existence.

## 5. Active Constraints
- Apply `AGENTS.md` project policy: Build Mode by default, numbered versions only, preserve explicit user intent, and do not commit/tag/release/publish/install/delete unless explicitly asked.
- For repo maintenance, apply the engineering-project-standard skill.
- For browser automation, use Chrome unless the user explicitly asks otherwise.
- Flow Design is a native macOS app; core local authoring, save/reopen, deterministic validation, and export must not depend on provider availability.
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
  - `git diff --check` passed for tracked diff; no-index whitespace checks on `docs/completed-tasks.md` and `handoff.md` produced no warnings.
- Not run:
  - `swift build`
  - `swift test`

## 7. Files to Open First
- `AGENTS.md`: repo rules and verification commands.
- `handoff.md`: hot current-state checkpoint.
- `docs/completed-tasks.md`: concise completed-work ledger.
- `docs/prd-unified-v2.md`: active product requirements source of truth.
- `docs/architecture.md`: implementation boundary and provider-registry alignment guidance.
- `docs/review/flow-design-provider-registry-alignment.md`: source review requirements that drove the docs update.

## 8. Next Actions
### Next
- Decide whether to commit the new continuity files.
- If continuing implementation, start from `docs/prd-unified-v2.md` and `docs/architecture.md`, then design the first concrete `FlowDesignAI` / invocation bridge slice before writing runtime code.

### Blocked
- None known.

### Later
- Add app-bundle build/launch verification once the Xcode project or project-generation path exists.
- Add repo-local handoff helper scripts if this repo will maintain handoffs regularly.

## 9. Ready-Made Prompt for Starting a New Thread
Read `handoff.md` as the hot current-state source for `/Users/paulmarshall/Software Development/flow-design`. Review `AGENTS.md`, `docs/prd-unified-v2.md`, `docs/architecture.md`, and `docs/review/flow-design-provider-registry-alignment.md` before making changes. Treat the provider-registry alignment at `8ea0236` as confirmed, distinguish confirmed repo state from new recommendations, and do not load broader context unless the task clearly requires it.
