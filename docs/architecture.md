# Architecture

## Product Shape

Flow Design is an Apple-native macOS document editor for creating, explaining, and maintaining standard flowcharts. The default implementation direction is Swift, SwiftUI, async/await, and Observation-based state on modern targets.

The product foundation is captured in [Product Fundamentals](product-fundamentals.md).

## Boundaries

- `FlowDesignApp` owns the window, navigation, commands, and app lifecycle.
- `FlowDesignCore` owns document and canvas domain types that should stay free of UI framework assumptions.
- `FlowDesignPaperKit` owns PaperKit, PencilKit, AppKit, and SwiftUI bridge code.
- `FlowDesignAI` should own AI task definitions, prompt versions, context construction, structured output schemas, provenance mapping, readiness checks, and conversion of generated output into reviewable document records.
- `FlowDesignInvokeBridge` should own the boundary between the native app and the shared provider invocation libraries.
- `Resources` holds future app bundle resources such as assets, icons, previews, and document-type resources.

## Domain Direction

`FlowDesignCore` should model semantic flow data separately from rendered PaperKit markup. Flow documents should preserve stable flow elements, connections, text sections, view types, and provenance so both users and Codex can edit the same flow safely.

PaperKit remains the native interaction and rendering surface. It should not become the only source of truth for app flow meaning.

Flow Design should use a native document package as the durable artifact. The package should store canonical semantic flow data in JSON and keep PaperKit data, previews, and provenance as separate package members.

Provider-backed AI is an app-owned service capability, not a registry feature and not UI behavior. SwiftUI views, AppKit controllers, PaperKit adapters, document save/load code, and semantic model types must not call provider SDKs directly. They should ask `FlowDesignAI` to run a named app task, receive validated proposal/finding/explanation records, and let normal document review and undo/redo flows apply accepted changes.

The shared provider registry is provider-catalog infrastructure only. It may supply profiles, provider configs, capabilities, readiness or health metadata, endpoint/model metadata, enabled state, and secret references. Flow Design must own its documents, semantic JSON, prompts, task definitions, proposals, task-run history, provenance, scan snapshots, review findings, change-impact records, and lifecycle state.

`FlowDesignInvokeBridge` may be a small local Node command, helper process, or IPC service that imports the shared `@invoke-providers/*` packages. It should be launched only when provider-backed AI features are used. The core local authoring loop must still create, edit, validate deterministically, save, reopen, and export documents without the registry, providers, browser runtime, or helper process being available.

The bridge should use these shared packages when AI integration is implemented:

- `@invoke-providers/client` for registry-backed client access and target-app runtime support.
- `@invoke-providers/core` for task definitions, readiness checks, structured-output validation, invocation orchestration, hook contracts, and task-run provenance.
- `@invoke-providers/adapters` for implemented provider adapter families.

Do not import `@invoke-providers/react` into the native production app unless a separate browser/React companion surface is deliberately added. Do not use `@invoke-providers/registry` as Flow Design app storage.

Flow Design should read provider-registry launch context from:

- `INVOKE_PROVIDERS_REGISTRY_URL`
- `INVOKE_PROVIDERS_PROFILE`
- `INVOKE_PROVIDERS_COMMIT_SHA`

The saved Flow Design setting `selectedProviderProfileKey` is the app's durable provider-profile choice. `INVOKE_PROVIDERS_PROFILE` is only a bootstrap default. If the saved profile no longer exists, keep the saved key, block AI readiness, and ask the user to choose a valid profile. Do not silently fall back to another provider or local provider.

## PaperKit Integration

The installed macOS 26.5 SDK exposes PaperKit as a Swift module. The scaffold uses `PaperMarkupViewController`, `PaperMarkup`, and `FeatureSet.latest` behind a dedicated adapter target so app code does not depend directly on PaperKit symbols everywhere.

## Verification

The initial root verification path is:

```bash
swift build
swift test
```

Add app-bundle build verification after the Xcode project or project-generation path exists.
