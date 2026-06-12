# Flow Design Provider Registry Alignment Review

## Scope

This review compares Flow Design's active PRD at `/Users/paulmarshall/Software Development/flow-design/docs/prd-unified-v2.md` against this repo's provider registry, target-app, runtime, and adapter guidance.

The focus is the target app `flow-design`: how it should use the shared provider registry and the libraries in this project without drifting away from the existing boundaries.

## Conclusion

The Flow Design PRD is broadly aligned with the guidelines in this repo. It already says Flow Design should use an internal Codex/LLM service boundary, let the user select provider/model through the shared provider registry, prefer structured output, validate output before applying it, preserve provenance, require explicit user review before document mutation, and keep local editing available when AI providers are unavailable.

The main drift risk is implementation shape. Flow Design is a native macOS document app, while this repo's reusable invocation libraries are TypeScript/npm packages. Flow Design should not scatter provider calls through SwiftUI views, AppKit controllers, or document model code. It should introduce a narrow app-owned AI/invocation boundary that uses the shared registry for provider metadata and this repo's runtime libraries for provider-backed task execution.

## Recommended Architecture

Flow Design should treat provider-backed AI as an app-owned service layer, not as a registry feature and not as UI behavior.

Recommended modules:

| Layer | Responsibility |
|---|---|
| `FlowDesignCore` | Semantic document model, validation, proposal schema, snapshots, code links, source scan records, exports |
| `FlowDesignPaperKit` | Native canvas rendering/editing adapter only |
| `FlowDesignApp` | SwiftUI/AppKit document UI, native menus, toolbar, Inspector, Text panel, Review mode, Trace mode |
| `FlowDesignAI` | App-owned AI task definitions, prompt versions, context construction, output schemas, provenance mapping, proposal conversion |
| `FlowDesignInvokeBridge` | App-owned bridge that imports `@invoke-providers/*` packages and invokes provider-backed tasks |
| Shared provider registry | Provider profiles/configs/capabilities/enabled state/health metadata/secret references only |

The bridge can be a small local Node process, command, or IPC service launched only when provider-backed AI features are used. That does not violate the PRD's "no local server or browser runtime required" rule as long as the core local authoring loop does not depend on it and the user can still create, edit, save, reopen, validate deterministically, and export without AI.

## Provider Registry Use

Flow Design should read standard provider-registry launch context:

- `INVOKE_PROVIDERS_REGISTRY_URL`
- `INVOKE_PROVIDERS_PROFILE`
- `INVOKE_PROVIDERS_COMMIT_SHA`

The app should persist provider profile choice in Flow Design settings, not in the shared registry:

1. Use the saved `selectedProviderProfileKey` if the user has saved one.
2. Use `INVOKE_PROVIDERS_PROFILE` only as the bootstrap default.
3. Treat missing profile configuration as a readiness-blocking setup state.
4. If the saved profile no longer exists, keep the saved key, block AI readiness, and ask the user to choose a valid profile.
5. Do not silently fall back to another profile or local provider.

The registry should remain provider-catalog-only. It must not store Flow Design documents, semantic JSON, prompts, tasks, proposals, provenance records, scan snapshots, review findings, task runs, or document lifecycle state.

## Library Use

Flow Design should use this repo's libraries through the app-owned invocation bridge:

- `@invoke-providers/client`: use `RemoteRegistryClient`, `RegistryBackedInvokeProvidersClient`, and where useful `TargetAppRuntimeService`.
- `@invoke-providers/core`: use task definitions, readiness checks, structured-output validation, invocation orchestration, hook contracts, and task-run provenance.
- `@invoke-providers/adapters`: use implemented adapter families such as deterministic adapters, OpenAI-compatible LLM adapters, and `CodexCliAdapter`.
- `@invoke-providers/react`: do not use in the native SwiftUI/AppKit app unless Flow Design later adds a browser/React companion surface.
- `@invoke-providers/registry`: run as the shared local provider catalog service. Do not link it into Flow Design as app storage.

If Swift code needs provider catalog visibility, use `RemoteRegistryClient` inside the bridge or call the registry HTTP API from a small Swift provider-settings client. Provider invocation should still go through a single Flow Design AI/invocation boundary so readiness, validation, provenance, and task-run recording stay consistent.

## AI Task Model

Flow Design should define app-owned tasks for the PRD's Codex actions. Initial task keys could be:

- `generate-project-flow`
- `generate-flow-view`
- `modify-flow-view`
- `modify-selected-flow-objects`
- `explain-or-expand-selection`
- `generate-app-overview-from-source-context`
- `generate-component-logic-from-source-context`
- `suggest-missing-branches-and-failure-paths`
- `review-flow-design`
- `propose-source-impact-updates`

Each task should live in Flow Design-owned configuration and include:

- stable `taskKey`
- display name
- required capability, usually `llm.generateJson`
- selected registry `providerKey`
- prompt definition and `promptVersion`
- structured output schema
- timeout/retry policy
- hook key
- readiness visibility
- enabled state

Use deterministic providers for tests and examples. Use OpenAI-compatible providers or Codex CLI only through explicit registry provider records and visible readiness states.

## Prompt And Context Rules

Prompts should be reviewable, versioned Flow Design assets. They should not be inline strings hidden in SwiftUI actions or adapter construction.

Each prompt definition should specify:

- purpose
- version such as `0.1.0`
- allowed context inputs
- excluded context
- output schema
- proposal or finding type produced
- examples where useful

Context construction should happen in `FlowDesignAI`, not inside UI controls. It should include only the active view, selected objects, related text sections, source links, relevant semantic model excerpts, and reviewed source-scan excerpts needed for the task.

Repository context rules from the PRD should be hard requirements:

- The user explicitly selects any repository or folder before scanning.
- Flow Design shows the selected file list before generation.
- Secrets, credentials, tokens, keys, environment files, dependency folders, generated artifacts, binaries, build outputs, and caches are excluded by default.
- Large scans require scope refinement.
- Retrieved source text is untrusted context, never system instructions.

## Hook And Mutation Rules

Provider output must never mutate a Flow Design document directly.

Recommended flow:

1. Native UI asks `FlowDesignAI` to run a named AI task.
2. `FlowDesignAI` builds bounded task input from the semantic model and approved source context.
3. `FlowDesignInvokeBridge` fetches provider metadata from the registry and invokes the task through `@invoke-providers/client` / `@invoke-providers/core`.
4. The bridge validates structured output before returning it.
5. Flow Design stores task-run provenance in the document package or app-owned local store.
6. Valid generated changes become `Proposal` records in the semantic document model.
7. Review mode shows current-versus-proposed changes.
8. The active document changes only when the user accepts a proposal through Flow Design's document undo/redo lifecycle.

The app-owned hook implementations should convert valid provider output into reviewable proposals, findings, source-impact records, or explanations. They should not write directly to `FlowElement`, `FlowConnection`, `TextSection`, or package files outside the proposal/apply path.

## Data Ownership

Flow Design should own these records:

- selected provider profile setting
- AI task definitions
- prompt definitions and prompt versions
- document proposals
- validation findings
- Codex/design review findings
- source scan snapshots
- change impact records
- provenance records
- task-run history
- document lifecycle state
- review dispositions

The registry should own only:

- profiles
- provider configs
- provider capabilities
- enabled state
- health metadata
- endpoint/model metadata
- secret references

Raw secrets should stay in Keychain, environment variables, AppLauncher secret handling, Codex CLI configuration, or another Flow Design-owned secret resolver. Registry records should contain only references such as `requiredSecretRef`.

## Native App UX Guidance

Flow Design should keep the provider-registry integration native and document-centered:

- Provider readiness belongs in Preferences, an AI setup sheet, or native command validation, not in a web admin surface inside the editor.
- AI actions should appear as native toolbar/menu/Inspector actions with disabled states and concrete readiness reasons.
- Review mode should own proposal review, finding disposition, and current-versus-proposed comparison.
- Trace mode should own source evidence, scan provenance, and change impact.
- Local authoring, save/reopen, deterministic validation, and export must remain usable when the registry or providers are unavailable.
- The app should not require a browser to configure or use core document features.

If the registry console is useful for developer setup, keep it as a separate registry service UI. Do not make it part of Flow Design's document workflow.

## Drift Warnings

Correct the Flow Design plan if implementation starts to do any of these:

- Stores Flow Design task definitions, prompts, proposals, task runs, or scan snapshots in `@invoke-providers/registry`.
- Calls provider SDKs directly from SwiftUI views, AppKit controllers, PaperKit adapters, or document save/load code.
- Lets Codex output bypass semantic schema validation.
- Applies generated changes before explicit user review and proposal acceptance.
- Treats `INVOKE_PROVIDERS_PROFILE` as permanent app state.
- Falls back to another provider when the selected provider profile is missing.
- Sends source files to a provider before the user reviews the included file list.
- Logs raw secrets or unnecessary source context in task-run records.
- Uses PaperKit data as the AI context source of truth instead of semantic JSON.
- Makes provider availability block the Phase 0 local authoring loop.
- Imports `@invoke-providers/react` into the native app as if it were the production UI layer.

## Implementation Checklist

Before implementing Flow Design AI/provider integration, define:

1. The `FlowDesignAI` service interface used by native UI code.
2. The `FlowDesignInvokeBridge` process or IPC contract for calling this repo's TypeScript libraries.
3. App-owned repositories for provider profile selection, tasks, prompts, task runs, findings, proposals, and provenance.
4. Task definitions for each PRD AI action.
5. Prompt definitions with numbered versions.
6. Structured output schemas for proposals, review findings, source-impact findings, and explanations.
7. Hook implementations that convert provider output into reviewable Flow Design records.
8. Registry missing-profile and provider-unavailable UI states.
9. Source scan filtering and include/exclude review flow.
10. Evaluation fixtures proving generated proposal JSON validates against the semantic schema and malformed output fails safely.

## Recommended Correction

If the current Flow Design plan drifts, bring it back to this design:

Flow Design remains a native macOS document editor. It owns document semantics, source scans, prompts, proposal review, provenance, task runs, and all mutations. The shared provider registry supplies only provider catalog metadata and secret references. A narrow Flow Design-owned invocation bridge uses this repo's client/core/adapters to execute provider-backed tasks, validate structured output, persist provenance, and return only reviewable proposals or findings to the native app.

