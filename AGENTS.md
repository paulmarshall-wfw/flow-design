# AGENTS.md

## Core Skill Policy

For any repo setup, maintenance, versioning, or stack-selection work, apply the engineering-project-standard skill from `~/.codex/skills/engineering-project-standard`.

For any frontend UI design, scaffolding, review, or refinement work, apply the web-app-design-standard skill from `~/.codex/skills/web-app-design-standard`.

For any Docker, container, image build, image publishing, registry push, or container release work, apply the docker-build-and-publish skill from `~/.codex/skills/docker-build-and-publish`.

For browser automation, use Chrome unless the user explicitly asks for a different browser or Chrome is unavailable.

## Broad Project Policy

Prefer explicit user intent over convenience defaults. Defaults may suggest values or preselect options, but they are not permission to mutate state, activate features, publish, overwrite files, commit, tag, release, install, delete, send, or navigate/change app or browser state unless the user explicitly chooses or requests that action.

- Default to Build Mode unless the user explicitly asks for release behaviour.
- Never use `latest`.
- Always use numbered versions.
- When the project is in Git, prefer Git-derived traceability by default.
- When distribution beyond local or dev use is explicitly requested, require publishable images to support both `linux/amd64` and `linux/arm64`.
- Do not let container distribution work overwrite or weaken existing Codex instructions in this file.

## Repo Workflow Notes

- Install command: no dependency install is currently required.
- Development command: `./scripts/build_and_run.sh --verify`
- Test command: `swift test`
- Lint or typecheck command: no dedicated lint command exists yet.
- Build command: `swift build`
- Xcode project generation command: `python3 scripts/generate_xcode_project.py`
- Xcode app build command: `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO build`
- Xcode app test command: `xcodebuild -project FlowDesign.xcodeproj -scheme FlowDesign -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/XcodeDerivedData CODE_SIGNING_ALLOWED=NO test`
- Full verification command: run `swift build`, `swift test`, generate the Xcode project, then run the Xcode app build and test commands.

## Runtime Notes

- Local app URL: not applicable; this is a native macOS app.
- API or service port: none.
- Registered local ports: none.
- Data directory: not defined yet.
- Important environment variables: none defined yet.
- External services: none.
- Background jobs or workers: none.
- App bundle output: `.build/XcodeDerivedData/Build/Products/Debug/FlowDesign.app`.

## Port Registry

Before adding or changing local ports, check and update `/Users/paulmarshall/Software Development/All Standards/local-port-registry.md`; record project ports in this file's Runtime Notes. After updating, run:

```bash
python3 "/Users/paulmarshall/Software Development/All Standards/scripts/check-local-port-registry.py"
```

## Verification Notes

- Prefer one root verification command when the repo supports it.
- If browser validation is needed, use Chrome unless the user asks otherwise.
- If a dev server chooses a fallback port, use the actual URL printed by the running server.
- If a test, lint, build, or verify command is missing, report that gap directly.

## Documentation And State

- If `handoff.md` or `HANDOFF.md` exists, read it before maintenance or implementation work.
- If `project-dossier.md` exists, use it for durable architecture and historical context.
- Keep `handoff.md` concise and current; put broader durable context in `project-dossier.md`.
- Update docs when changing user-facing behavior, workflows, setup, deployment, or verification.

## Project-Specific Constraints

- Product scope: native macOS app for PaperKit-based flow/canvas design.
- Local-only or deployment expectations: Build Mode by default; no release or distribution path exists yet.
- Authentication model: none.
- Storage model: not defined yet.
- UI direction: Apple-native SwiftUI shell with AppKit interop for PaperKit.
- App-bundle path: generated Xcode project from SwiftPM-friendly source layout; see `docs/technical-decisions.md`.
- Release boundaries: local unsigned Build Mode only; no signed release, notarization, or distribution path exists yet.

## Agent Notes

- Inspect relevant files before editing.
- Preserve explicit user requirements and stronger project-local instructions.
- Keep changes scoped to the requested work.
- Do not commit, tag, release, publish, install dependencies, or delete files unless the user explicitly asks.
- Report verification performed and any verification that could not be run.
