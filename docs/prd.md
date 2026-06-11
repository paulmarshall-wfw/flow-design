# Product Requirements Document

## Product

Flow Design

## Status

Draft for product definition.

## Summary

Flow Design is a native macOS app for designing, explaining, and maintaining application flows with standard flowcharts. It combines a structured text panel, a semantic flowchart canvas, reusable flow templates, and Codex-assisted generation so users can plan new apps and document existing apps in one local design workspace.

The app is built around co-authoring between the user and Codex. Either party can create or modify a flow, but all changes should remain editable, reviewable, and grounded in a durable semantic flow model.

## Problem

Designing app behavior often splits across notes, diagrams, source files, and ad hoc AI conversations. This makes it hard to keep the intended app flow, implementation logic, and current system behavior aligned.

Current pain points:

- Flowcharts are often static drawings with no structured meaning for later editing.
- AI-generated diagrams are hard to revise precisely after generation.
- Notes about features, happy paths, and component logic drift away from diagrams.
- Existing apps are difficult to summarize visually without manual tracing.
- Reusable app-flow patterns are not captured as first-class templates.

## Goals

- Let a user create standard flowcharts from a blank canvas.
- Let Codex generate standard flowcharts from prompts.
- Let either the user or Codex modify flows created by the other.
- Pair every project flow with structured text sections for app synopsis, major features, happy path, and component logic.
- Support separate diagram views for app overview, happy path, and component logic.
- Let Codex generate flowcharts that describe processing flows in an existing app.
- Provide a local library of saved project flows and template flows.
- Keep flow meaning in a semantic model, not only in rendered canvas markup.
- Use a package document as the primary design artifact, with JSON as the semantic source of truth and PaperKit data stored as separate package data.

## MVP Objectives

- Help move from "diagram" to "buildable plan" while preserving traceability back to design intent and source evidence.
- Make flows implementation-ready, not just visually clear.
- Keep design intent linked to source-code reality over time.
- Help Codex produce better implementation plans from diagrams.
- Support maintenance workflows, not only greenfield app design.
- Make ambiguity visible, including missing branches, undefined states, unclear ownership, and unhandled errors.

## Non-Goals For The First Usable Product

- Multi-user collaboration.
- Cloud sync.
- Publishing or distribution workflow.
- Existing-app analysis without an explicitly selected repository.
- Replacing dedicated whiteboard or general-purpose vector design tools.
- Freehand drawing as a first-version canvas mode.
- Letting Codex silently mutate a document without user review.

## Target User

The primary user is an app builder who collaborates with Codex to design, implement, review, or maintain software.

They need to:

- sketch and revise app behavior quickly
- move between high-level and detailed views
- keep prose and diagrams aligned
- use Codex to accelerate first drafts and app analysis
- retain control over final document changes

## Core User Stories

- As a user, I can create a new blank project flow so I can design an app from scratch.
- As a user, I can add standard flowchart elements and connections so the diagram follows a recognizable notation.
- As a user, I can switch between app overview, happy path, and component logic views so I can work at the right level of detail.
- As a user, I can write an app synopsis, major features, happy path description, and component logic notes beside the canvas.
- As a user, I can ask Codex to generate a flow from a prompt so I can get a useful starting point quickly.
- As a user, I can review Codex-proposed changes before applying them so I remain in control.
- As a user, I can ask Codex to generate a flow for an existing app by selecting a repository for Flow Design to scan so I can understand or document current behavior.
- As a user, I can see validation warnings for ambiguous or incomplete flows so I can improve them before implementation.
- As a user, I can link flow elements to source files, modules, symbols, docs, or commands so the diagram remains connected to implementation evidence.
- As a user, I can compare rescans of an existing app so I can see what changed since the last analysis.
- As a user, I can export flow-backed Markdown for PRDs, architecture docs, handoff docs, README snippets, or implementation briefs.
- As a user, I can save project flows and start from template flows so repeat work is faster.

## Experience Requirements

### Workspace

The main window should be a native macOS editor workspace with:

- project/library sidebar
- structured text panel
- central canvas
- object/view inspector
- native toolbar and menu commands

The canvas is the primary work surface. Text, library, and inspector surfaces support the canvas rather than displacing it.

### Text Panel

The text panel must support these initial sections:

- App Synopsis
- Major Features
- Happy Path Description
- Logic Description

Text should be linkable to flow views and selected flow elements. Component logic notes should be easy to associate with the relevant module, feature, or component view.

### Flow Views

Each project flow must support these initial view types:

- App Overview: major app surfaces, modules, services, stores, and integrations.
- Happy Path: primary successful user or system path through the app.
- Component Logic: detailed logic for a module, feature, component, or workflow.
- Failure Path: unhappy paths, retry paths, cancellation, permissions, empty states, and error handling.

The user should be able to create, rename, switch, and delete flow views, with appropriate protection against deleting the last useful view.

### Flowchart Canvas

The first canvas implementation must prioritize structured flowchart objects only. Freehand sketching can be considered later as a separate layer, but it should not dilute the semantic flow model in the first usable product.

The canvas must support:

- standard flowchart element creation
- element selection, move, resize, rename, and delete
- directional connections between elements
- connection labels and decision branch labels
- pan, zoom, fit, and reset view
- undo and redo
- alignment aids such as grid, snap, or guides

Initial standard element types:

- start/end
- process
- decision
- input/output
- data store
- document
- connector
- subflow/module
- actor/system boundary
- annotation

### Codex Assistance

Codex assistance must be explicit and reviewable.

Initial Codex actions:

- generate new project flow from prompt
- generate a specific flow view
- modify a selected flow view from instruction
- explain or expand selected elements
- generate app overview from selected existing-app context
- generate component logic from selected files or modules
- suggest missing branches, unclear transitions, or failure paths
- review a flow for missing states, confusing paths, excessive complexity, and implementation risks

Codex output must validate against the semantic flow schema before it can be applied.

Codex proposals must be reviewed in a side-by-side diff before document mutation. The diff should make additions, removals, and edits clear for both diagram structure and linked text sections.

### Traceability Panel

The workspace must include a traceability panel or inspector mode that explains why a flow element exists.

For generated content, it should show:

- source files, modules, docs, or commands used as evidence
- prompt and generation record
- repository scan that supplied the evidence
- whether the element was generated, user-authored, edited, or accepted from a proposal

For user-authored content, it should allow manual links to files, modules, symbols, docs, and commands.

### Library

The library must include:

- Saved Project Flows
- Template Flows

Initial template candidates:

- basic app overview
- CRUD app
- document-based macOS app
- import/review/approve workflow
- AI-assisted generation workflow
- background job workflow
- error and retry workflow

## Functional Requirements

### MVP Features

The MVP must include flow validation, code links, change impact, local snapshots, flow-to-doc export, design review mode, failure path views, traceability, and acceptance criteria. The detailed requirements below define those features alongside the base editor requirements.

### Project Flow Documents

- Create a new project flow.
- Open an existing project flow.
- Save and reopen local project flows.
- Store document metadata, text sections, flow views, elements, connections, and generation provenance.
- Preserve stable IDs for flow elements and connections.

### Semantic Flow Model

- Represent flow elements independently from canvas rendering.
- Represent connections independently from drawn connector strokes.
- Preserve labels, notes, element type, layout geometry, and view membership.
- Allow generated and user-authored flows to use the same model.
- Store acceptance criteria for individual nodes and views as "done when" notes.
- Store code links from elements to repository files, modules, symbols, docs, or commands.
- Store validation state without treating validation warnings as destructive document changes.

### Flow Validation And Linting

- Detect disconnected nodes.
- Detect decision branches without labels.
- Detect missing error paths where a step has obvious failure modes.
- Detect duplicate or near-duplicate concepts.
- Detect unclear, missing, or multiple unintended start and end points.
- Surface validation findings without blocking editing.
- Allow findings to link back to the affected node, connection, or view.

### Acceptance Criteria

- Let the user attach acceptance criteria to a flow view.
- Let the user attach acceptance criteria to an individual node.
- Preserve acceptance criteria in the semantic document model.
- Include acceptance criteria in exports intended for implementation briefs or handoff docs.

### Canvas Rendering

- Render semantic flow elements into an editable native canvas.
- Keep PaperKit integration behind the adapter target.
- Preserve enough PaperKit markup or rendering data to support native canvas editing.
- Avoid making PaperKit markup the only durable source of flow meaning.
- Treat PaperKit data as package-member rendering data, not as the semantic model.

### Existing App Flow Generation

- Let the user manually select a repository as the starting context.
- Scan the selected repository to derive candidate files, modules, docs, and app structure.
- Let the user refine which scanned files, folders, or docs are included as generation context.
- Let the user specify the desired view type and prompt.
- Record source context and generation provenance.
- Validate generated flow output before showing it as a proposal.
- Require user acceptance before modifying the active document.

### Change Impact View

- Store repository scan snapshots for project flows linked to existing apps.
- Compare a new scan with the previous accepted scan.
- Show changed, added, removed, and potentially impacted files, modules, docs, or commands.
- Highlight flow elements and views whose source evidence changed.
- Let the user ask Codex to propose flow updates from the impact view.

### Templates

- Bundle a starter set of template flows.
- Allow a user to create a new project flow from a template.
- Preserve template provenance in the new document metadata where useful.

### Version History And Snapshots

- Support local document snapshots.
- Let the user name milestones such as "Initial Codex draft", "Post-review", and "Implemented".
- Preserve enough snapshot metadata to understand who or what created the milestone.
- Let the user compare meaningful document versions at the flow/view level.

### Flow-To-Doc Export

- Export Markdown sections for PRDs.
- Export Markdown sections for architecture docs.
- Export Markdown sections for handoff docs.
- Export README snippets.
- Export implementation briefs.
- Include linked acceptance criteria and source evidence where relevant.

## AI Requirements

- Use an internal Codex/LLM service boundary rather than scattering provider calls through UI code.
- Store prompt definitions as reviewable, versioned assets where practical.
- Prefer structured output for generated flow changes.
- Validate structured output before applying it.
- Provide safe failure states for invalid output, timeout, provider errors, and low-confidence results.
- Preserve provenance for generated content.
- Keep user review as the default gate before document mutation.
- Support a design review mode where Codex critiques a flow for missing states, confusing paths, excessive complexity, and implementation risks.

## Data Requirements

The durable document model should include:

- document ID and title
- metadata
- text sections
- flow views
- flow elements
- flow connections
- layout geometry
- template source when applicable
- source-app context when applicable
- Codex generation history
- review/applied state for generated proposals
- code links
- validation findings
- acceptance criteria
- local snapshots and milestone names
- repository scan snapshots
- change impact records

The preferred file format is a native document package. The package should keep the semantic flow document in JSON and store PaperKit data, previews, generated artifacts, and provenance sidecars as separate package members.

Initial package shape:

- `document.json`: canonical semantic project flow model
- `paperkit/`: PaperKit data keyed by flow view or canvas ID
- `previews/`: optional generated preview images
- `provenance/`: optional Codex generation records and source-scan summaries
- `snapshots/`: optional local document milestone snapshots
- `exports/`: optional generated Markdown exports

The JSON model remains the source of truth for project metadata, text sections, flow views, elements, connections, layout geometry, and proposal state.

## Platform Requirements

- Native macOS app.
- Swift and SwiftUI app shell.
- AppKit interop for PaperKit surfaces.
- Local-first document behavior.
- Native menus for document, edit, view, import, export, and help commands.
- Keyboard shortcuts for common editor actions.
- No local server or browser runtime required.

## Quality Requirements

- Build and test from the repo root.
- Keep core flow-model logic in `FlowDesignCore` with automated tests.
- Keep PaperKit-specific behavior isolated in `FlowDesignPaperKit`.
- Keep UI state separate from durable document semantics.
- Add tests for document creation, flow element validation, connection validation, template instantiation, and Codex output validation as those features are introduced.

## First Usable Product Scope

The first useful version should prove the local authoring loop:

1. Create a project flow.
2. Edit structured text sections.
3. Switch between app overview, happy path, and component logic views.
4. Add standard flow elements.
5. Connect elements with labeled directional links.
6. Save and reopen the project flow.
7. Create a project flow from a bundled template.
8. Validate flows for disconnected nodes, unlabeled decision branches, missing error paths, duplicate concepts, and unclear start/end points.
9. Link flow elements to repository files, modules, symbols, docs, or commands.
10. Scan a selected repository and preserve source evidence.
11. Show change impact when an existing-app repository is rescanned.
12. Save local named snapshots.
13. Export Markdown for PRDs, architecture docs, handoff docs, README snippets, and implementation briefs.
14. Review and apply a Codex-generated proposal in a side-by-side diff once AI integration exists.
15. Use Codex design review mode to critique ambiguity, missing states, complex paths, and implementation risks once AI integration exists.

## Future Features

- Generated implementation plan: turn an accepted flow into a build plan, task list, or work-order style checklist.
- Import from text: paste a PRD, README, or rough notes and generate a structured starting flow.
- State ownership labels: mark whether a step is user action, UI state, backend state, external service, background job, or AI action.
- Reusable component palette: saved modules like auth flow, import flow, review queue, document save, and AI proposal review.

## Open Questions

- How much PaperKit data is required for reliable native editing when semantic JSON is the source of truth?
- Should the text panel be always visible, collapsible, or mode-specific?
- Should template flows be bundled only, user-editable, or both?
- What is the first export target: image, PDF, Markdown, or a structured flow JSON?
