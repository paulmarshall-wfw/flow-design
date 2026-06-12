# Completed Tasks

Append brief entries here when project work is completed. Keep this file concise and append-only.

## 2026-06-12

- Task: Align provider-registry AI requirements in repo docs.
  Outcome: Updated the active PRD, architecture, product fundamentals, UX guidance, and README so Flow Design keeps provider-backed AI behind app-owned boundaries and uses the shared registry only for provider catalog metadata and secret references.
  Verification: `git diff --check` passed during the docs pass; Swift build/test were not run because the change was documentation-only.
  Traceability: `8ea0236` on `main`; files changed: `README.md`, `docs/architecture.md`, `docs/prd-unified-v2.md`, `docs/product-fundamentals.md`, `docs/ux-design.md`, `docs/review/flow-design-provider-registry-alignment.md`.

- Task: Assess pre-build readiness.
  Outcome: Confirmed the SwiftPM scaffold builds and tests, and identified the remaining work before starting the first product build slice.
  Verification: `swift build` passed; `swift test` passed with 1 XCTest; initial sandboxed attempts failed only because Swift could not write its normal user module cache.
  Traceability: `d674fbf` on `main`; reviewed `Package.swift`, `Sources/`, `Tests/`, `README.md`, `docs/architecture.md`, `docs/prd-unified-v2.md`, `docs/product-fundamentals.md`, and `docs/ux-design.md`.

- Task: Define early app-build stack decisions.
  Outcome: Added a generated Xcode app-bundle path, local launch verification script, app metadata files, and `docs/technical-decisions.md` covering signing, document packages, schema versioning, PaperKit strategy, UI architecture, CI/static analysis, launch verification, and AI bridge lifecycle.
  Verification: `swift build` passed; `swift test` passed with 1 XCTest; `xcodebuild ... build` passed; `xcodebuild ... test` passed with 1 XCTest after rerunning outside the sandbox; `xcodebuild ... analyze` passed; `./scripts/build_and_run.sh --verify` built and launched `FlowDesign.app` and verified the `FlowDesign` process.
  Traceability: `1030588` on `main`; files changed include `FlowDesign.xcodeproj`, `Resources/`, `scripts/`, `docs/technical-decisions.md`, `README.md`, `AGENTS.md`, `docs/completed-tasks.md`, and `handoff.md`.

- Task: Add Phase 0 semantic document model.
  Outcome: Replaced the placeholder core document shape with schema-versioned `Codable` semantic flow types for app containers, flow views, flow elements, connections, text sections, acceptance criteria, code links, validation findings, proposals, and provenance records while preserving the app shell's canvas bridge.
  Verification: `swift build` passed; `swift test` passed with 4 XCTest cases; `python3 scripts/generate_xcode_project.py` regenerated `FlowDesign.xcodeproj`; `xcodebuild ... build` passed; `xcodebuild ... test` passed with 4 XCTest cases after rerunning outside the sandbox; `./scripts/build_and_run.sh --verify` built, launched, and verified the `FlowDesign` process.
  Traceability: working tree on `1030588`; files changed: `Sources/FlowDesignCore/FlowDesignDocument.swift`, `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift`, `docs/completed-tasks.md`, and `handoff.md`.

- Task: Add document package save and reopen support.
  Outcome: Added a core package-store boundary that saves semantic `document.json`, creates `paperkit`, `previews`, and `provenance` package directories, reloads packages through the schema-versioned JSON decoder, preserves sidecar files, and reports missing or invalid package paths explicitly.
  Verification: `swift build` passed; `swift test` passed with 8 XCTest cases; `python3 scripts/generate_xcode_project.py` regenerated `FlowDesign.xcodeproj`; `xcodebuild ... build` passed; `xcodebuild ... test` passed with 8 XCTest cases; `./scripts/build_and_run.sh --verify` built, launched, and verified the `FlowDesign` process.
  Traceability: working tree on `6a1ea94`; files changed: `Sources/FlowDesignCore/FlowDesignDocumentPackageStore.swift`, `Tests/FlowDesignCoreTests/FlowDesignDocumentTests.swift`, `scripts/generate_xcode_project.py`, `FlowDesign.xcodeproj/project.pbxproj`, `docs/completed-tasks.md`, and `handoff.md`.
