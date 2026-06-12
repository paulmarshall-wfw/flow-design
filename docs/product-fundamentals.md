# Product Fundamentals

## Intent

Flow Design is a native macOS editor for designing, explaining, and maintaining application flows with standard flowcharts.

The app's central idea is co-authoring: a user and Codex should be able to create and modify the same project flow. A diagram created by Codex must remain editable by the user, and a diagram created by the user must remain understandable and extensible by Codex.

## Primary Jobs

- Start from a blank canvas and draw a standard flowchart for a new app idea.
- Ask Codex to generate an initial flowchart from a prompt.
- Edit any generated or hand-drawn flowchart without losing semantic structure.
- Ask Codex to describe processing flows in an existing app as flowcharts.
- Maintain text explanations alongside diagrams so a flow stays useful for design, implementation, and review.
- Save reusable project flows and template flows for future work.

## Product Shape

Flow Design is a document-based native macOS editor. The dominant surface is a workspace with:

- a full-canvas flowchart workspace
- selectable app, container, node, connection, label, and view contexts
- an inspector for selected objects, views, validation, provenance, export, and Codex suggestions
- a sticky text panel for the selected semantic text section
- native menus and commands for documents, editing, view control, import, export, and undo

The app should feel like a focused design tool rather than a generic notes app or dashboard. The canvas is the primary work surface, and structured text supports the diagram rather than replacing it.

## Core Concepts

### Project Flow

A project flow is the top-level document. It represents one app, feature, module, or reusable template.

It contains:

- project metadata such as title, summary, source app path, and creation/update timestamps
- structured text sections
- one or more flow views
- reusable components and symbols
- Codex generation history and review state

### Flow View

A flow view is a named diagram perspective over the same project flow. Initial view types are:

- `App Overview`: major app surfaces, modules, services, stores, and integrations
- `Happy Path`: the main user or system path through the app
- `Component Logic`: detailed logic for one module, component, feature, or workflow

Views should share semantic entities where possible. For example, a module shown in the app overview should be linkable to its component logic view.

### Flow Element

A flow element is a semantic diagram object, not just a drawing mark.

Initial element types:

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

Each element should have stable identity, label text, optional long-form notes, type-specific properties, and layout geometry.

### Flow Connection

A flow connection links two flow elements.

Connections should support:

- direction
- label text
- condition text for decision branches
- relationship type, such as control flow, data flow, dependency, or navigation

### Canvas Markup

PaperKit markup is the presentation and interaction layer for drawing. The durable app model should preserve a semantic flow graph separately from rendered markup so Codex can safely generate, modify, diff, and validate flowcharts.

PaperKit should be treated as the native canvas surface, not the only source of truth for flow meaning.

The first canvas implementation should prioritize structured flowchart objects only. Freehand PaperKit sketching can be considered later as a separate layer if it does not weaken the semantic flow model.

### Document Package

Flow Design documents should be native document packages because project flows are primary design artifacts and will need room for semantic JSON, PaperKit data, previews, and provenance.

The initial package shape should be:

- `document.json`: canonical semantic project flow model
- `paperkit/`: PaperKit data keyed by flow view or canvas ID
- `previews/`: optional generated preview images
- `provenance/`: optional Codex generation records and source-scan summaries

The JSON model remains the source of truth for project metadata, text sections, flow views, elements, connections, layout geometry, and proposal state.

## Text Panel

The text panel stores structured project explanation beside the canvas.

Initial sections:

- App Synopsis: concise description of what the app does and who it serves
- Major Features: grouped feature list with status or priority where useful
- Happy Path Description: narrative walkthrough of the primary successful flow
- Logic Description: detailed explanation for selected components, modules, or features

Text sections should be linkable to flow views and selected flow elements. Selecting a component logic view should surface the relevant logic description without forcing the user to hunt through unrelated text.

## Canvas Tools

The canvas should support direct manipulation first.

Initial tool groups:

- selection, move, resize, align, group, and reorder
- flowchart shapes from the standard element set
- connector drawing with directional arrows and branch labels
- text labels and annotations
- pan, zoom, fit, and reset view
- undo and redo
- snap, grid, and alignment guides

Codex-generated diagrams should use the same element and connection model as user-drawn diagrams.

## Codex Assistance

Codex assistance should be explicit, reviewable, and bounded.

Initial Codex actions:

- generate a new project flow from a prompt
- generate a specific view for an existing project flow
- update a selected flow view from an instruction
- explain or expand selected flow elements
- create an app overview from an existing repository
- create component logic views from selected source files or modules
- suggest missing branches, failure paths, or unclear transitions

Codex should return structured flow output that validates against the app's flow schema before it can modify the document. The user should be able to review proposed changes before applying them.

Codex proposal review should make additions, removals, and edits clear for both diagram structure and linked text sections. The active Unified v2 review pattern is current-versus-proposed canvas comparison plus selected-object details in the Inspector; a separate side-by-side surface can be added later if needed.

Provider-backed Codex assistance should stay behind a Flow Design-owned AI boundary. Native views, AppKit controllers, PaperKit adapters, and document model code should not call provider SDKs directly. Flow Design should own task definitions, prompt versions, context construction, proposal conversion, task-run history, and provenance.

The shared provider registry should be used only for provider catalog data: profiles, provider configs, capabilities, readiness or health metadata, endpoint/model metadata, enabled state, and secret references. Flow Design should persist its selected provider profile in app settings, use launch context only as a bootstrap default, and block AI readiness rather than silently falling back when the saved profile is unavailable.

## Existing App Analysis

When describing an existing app, Flow Design should preserve provenance.

Generated flows should record:

- source repository or folder
- repository scan summary
- selected files, modules, or docs used as refined context
- generation prompt
- generated view type
- timestamp
- validation result

The first useful version should start with a manually selected repository, scan that repository for candidate files, modules, docs, and app structure, then let the user refine the context before generation. Embeddings and deeper source analysis can come later.

## Library

The library gives the user a way to start, reuse, and maintain flows.

Initial library sections:

- Saved Project Flows: user-created project documents
- Template Flows: reusable starter diagrams for common app patterns

Template candidates:

- basic app overview
- CRUD app
- document-based macOS app
- import/review/approve workflow
- AI-assisted generation workflow
- background job workflow
- error and retry workflow

## First Usable Product

The first usable version should focus on local, reliable authoring.

Minimum fundamentals:

- create a project flow document
- edit structured text sections
- create and switch between the three initial view types
- place standard flow elements on a canvas
- connect elements with labeled directional links
- save and reopen local project flows
- create a flow from a template
- accept or reject a Codex-generated flow proposal once AI integration exists

## Deliberate Boundaries

- Build Mode is the default; no release or distribution path is assumed yet.
- Local documents come before collaboration or cloud sync.
- Structured flowchart objects come before freehand drawing.
- Codex proposes structured changes; the user remains in control of applying them.
- Provider-specific AI integration should remain behind an internal abstraction that uses the shared registry only for provider catalog metadata and secret references.
- Core local authoring, save/reopen, deterministic validation, and export must keep working when the provider registry or AI providers are unavailable.

## Open Design Questions

- How much of PaperKit markup can be round-tripped cleanly with semantic flow elements?
- Should templates be bundled resources, user-editable documents, or both?
