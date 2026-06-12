# Completed Tasks

Append brief entries here when project work is completed. Keep this file concise and append-only.

## 2026-06-12

- Task: Align provider-registry AI requirements in repo docs.
  Outcome: Updated the active PRD, architecture, product fundamentals, UX guidance, and README so Flow Design keeps provider-backed AI behind app-owned boundaries and uses the shared registry only for provider catalog metadata and secret references.
  Verification: `git diff --check` passed during the docs pass; Swift build/test were not run because the change was documentation-only.
  Traceability: `8ea0236` on `main`; files changed: `README.md`, `docs/architecture.md`, `docs/prd-unified-v2.md`, `docs/product-fundamentals.md`, `docs/ux-design.md`, `docs/review/flow-design-provider-registry-alignment.md`.
