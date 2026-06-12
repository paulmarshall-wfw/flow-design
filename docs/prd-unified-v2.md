# Product Requirements Document: Unified v2

## Product

Flow Design

## Status

Draft for product definition and implementation planning.

## Source Documents

This PRD supersedes `docs/prd.md` for forward product planning without modifying that file. It adopts product, behavior, data, workflow, and implementation requirements from:

- `docs/prd.md`
- `docs/ux-design.md`
- `docs/ui-mockups/unified-v2-description.md`
- `docs/ui-mockups/unified-v2-top-toolbar.svg`

Pure UI and UX design detail remains in `docs/ux-design.md` and `docs/ui-mockups/`. This PRD describes required product behavior and implementation implications, not exact visual styling, sample mockup content, colors, sizes, or final layout pixel decisions.

Carry-forward rule: every active product requirement from `docs/prd.md` is preserved here unless this document explicitly replaces the old interaction mechanism. When the old PRD describes sidebars, a standalone text panel, or separate traceability/review panels, the preserved requirement is the underlying product capability; the replacement mechanism is the Unified v2 full-canvas workspace, selection-driven Inspector, sticky Text panel, and mode-driven context.

Archive readiness: after repository links are updated to point at this file, `docs/prd.md` may be archived as historical source material. Next-stage implementation work should use this file as the active product source of truth and should not consult the archived PRD unless explicitly researching product history.

## Original PRD Carry-Forward Map

| Original PRD concept | Unified v2 requirement |
|---|---|
| Balanced workspace with library/sidebar, structured text panel, central canvas, and inspector | Full-canvas workspace with selectable canvas objects, floating or toggleable secondary surfaces, selection-driven Inspector, and sticky Text panel |
| Structured text panel beside the canvas | Text sections owned by app containers, subflow/module containers, nodes, and flow views, edited through Inspector-driven Text panel access |
| Text linkable to flow views and selected flow elements | Text owner links are explicit semantic relationships; text is attached to the object or view it describes |
| Traceability panel | Traceability Requirements through Inspector and Trace mode |
| Change Impact mode/view | Named Change Impact workflow implemented as a Trace mode subview without losing rescan comparison and impact highlighting |
| Library sidebar with Saved Project Flows and Template Flows | Local Library requirement exposed through native document workflows, File menu actions, open panels, recent documents, or a later browser |
| Current vs Codex Proposal side-by-side diff | Review mode current-versus-proposed comparison; side-by-side view is allowed and before/after meaning must be unambiguous |
| Logic Description | Same product section as `Logic Notes` in the Unified v2 UI language |
| Change Impact highlighting of impacted views or elements | Change Impact must compare accepted scans and highlight impacted files, views, objects, and source-linked flow areas |
| MVP scope focused on local authoring loop | Phase 0 Core Authoring scope, with later MVP capabilities sequenced into Phase 1 and Phase 2 |

## Summary

Flow Design is a native macOS app for designing, explaining, reviewing, and maintaining application flows with standard flowcharts. It is a local-first document workspace where the canvas is the primary authoring surface, semantic flow data is the source of truth, and text, validation, provenance, review, and export details are attached to selectable flow objects.

The app is built around co-authoring between the user and Codex. Either party can create or modify a flow, but Codex-authored changes must remain explicit, reviewable, validated against the semantic model, and accepted by the user before they mutate the document.

## Problem

Designing app behavior often splits across notes, diagrams, source files, and ad hoc AI conversations. This makes it hard to keep intended app flow, implementation logic, source evidence, and current system behavior aligned.

Current pain points:

- Flowcharts are often static drawings with no durable structure for later editing.
- AI-generated diagrams are hard to revise precisely after generation.
- Notes about features, happy paths, failure paths, and component logic drift away from diagrams.
- Existing apps are difficult to summarize visually without manual tracing.
- Reusable app-flow patterns are not captured as first-class templates.
- Review, validation, provenance, and export decisions are often disconnected from the flow elements they describe.

## Goals

- Let a user create standard flowcharts from a blank canvas.
- Let Codex generate standard flowcharts from prompts.
- Let either the user or Codex modify flows created by the other.
- Pair every project flow with structured text sections for app synopsis, major features, happy path, and component logic.
- Support separate diagram and flow views for app overview, happy path, component logic, and failure paths.
- Keep flow meaning grounded in a durable semantic model, not only in rendered canvas markup.
- Make the canvas the single workspace for flow objects, containers, connections, labels, and selection.
- Make the Inspector the consistent way to inspect and edit selected objects.
- Attach text sections to the app container, subflow containers, individual nodes, and flow views.
- Let Codex generate and review flowcharts that describe processing flows in an existing app.
- Provide a local library of saved project flows and template flows through document workflows.
- Use a package document as the primary design artifact, with JSON as the semantic source of truth and PaperKit data stored as separate package data.
- Make ambiguity visible, including missing branches, undefined states, unclear ownership, missing evidence, and unhandled errors.

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
- Treating PaperKit data or visual rendering data as the durable source of flow meaning.
- Encoding exact visual styling from mockups as product requirements.

## Target User

The primary MVP user is a solo or small-team app developer who wants to design, explain, and maintain app behavior as implementation-ready flowcharts.

The user may collaborate with Codex, but AI use should not be required for the core authoring loop. Flow Design should remain useful as a structured local flowcharting and planning tool when Codex features are unavailable or disabled.

They need to:

- sketch and revise app behavior quickly
- move between high-level and detailed views
- keep prose and diagrams aligned
- attach source evidence to flow elements
- use Codex to accelerate first drafts, app analysis, and design review
- retain control over final document changes

## Product Principles

- The canvas is the single workspace. Flow content, containers, nodes, connections, labels, and scope live on the canvas as selectable, editable elements.
- Select to inspect. The Inspector is the consistent entry point for understanding and editing any canvas element or view.
- Modes reshape context, not the workspace. Switching modes changes the Inspector emphasis and canvas overlays without changing the underlying document, selection model, or editing surface.
- Text belongs to the thing it describes. App-level, module-level, node-level, and view-level text sections are properties of semantic objects.
- AI assistance is explicit and reviewable. Generated output appears as validated proposals before it mutates a document.
- Semantic JSON is the source of truth. Rendering data may cache presentation and interaction details, but cannot be the only durable representation of flow meaning.

## Core User Stories

- As a user, I can create a new blank project flow so I can design an app from scratch.
- As a user, I can select the app container, subflow containers, nodes, connections, labels, or empty view context and inspect their properties in one consistent place.
- As a user, I can add standard flowchart elements and connections so the diagram follows a recognizable notation.
- As a user, I can switch between app overview, happy path, component logic, and failure path views so I can work at the right level of detail.
- As a user, I can edit app synopsis, major features, happy path description, logic notes, node notes, and acceptance criteria from the selected object context.
- As a user, I can keep a text section open while selecting related objects so prose and diagram context stay aligned.
- As a user, I can ask Codex to generate a flow from a prompt so I can get a useful starting point quickly.
- As a user, I can review Codex-proposed changes before applying them so I remain in control.
- As a user, I can ask Codex to generate or review a flow for an existing app by selecting a repository or source files for Flow Design to scan.
- As a user, I can see validation warnings for ambiguous or incomplete flows so I can improve them before implementation.
- As a user, I can link flow elements to source files, modules, symbols, docs, or commands so the diagram remains connected to implementation evidence.
- As a user, I can compare rescans of an existing app so I can see what changed since the last accepted analysis.
- As a user, I can export flow-backed Markdown for PRDs, architecture docs, handoff docs, README snippets, or implementation briefs.
- As a user, I can save project flows and start from template flows so repeat work is faster.

## Experience Requirements

### Workspace Model

The main editor is a native macOS document workspace with a full-canvas authoring surface below the native window chrome and command surfaces.

The canvas is the primary work surface. Secondary surfaces support the canvas and should not permanently displace it. The product must support:

- a canvas that pans, zooms, scrolls, fits, and resets view
- selectable canvas objects for flow scope, nodes, connections, labels, containers, and annotations
- an Inspector surface driven by current selection and active mode
- a Text surface for editing the currently selected text section
- native toolbar and menu commands for document, edit, view, arrangement, formatting, review, import, export, help, AI, and panel visibility actions
- no required local server or browser runtime for the app experience

Exact panel placement, visual styling, and toolbar layout remain design-document concerns.

### App Container

Each project flow document has one canonical app container. Every flow view references and displays that same app container as the top-level scope for the view.

The app container must:

- be represented in the semantic model as a selectable canvas element
- be movable and resizable like other container elements, with geometry stored per view
- establish the top-level containment hierarchy for the current view
- provide the selection target for app-level properties
- own app-level text sections, app-level code links, app-level validation, and app-level provenance
- contain or reference flow nodes that belong to the current view

There must not be a separate app container per view unless a future schema version explicitly introduces nested app scopes. App Synopsis, Major Features, Happy Path Description, Logic Description / Logic Notes, app-level code links, app-level validation, and app-level provenance belong to the canonical document app container and are shared across views. A view may store its own layout geometry for the app container, but it must not duplicate app-level text or provenance.

The app container avoids special-case app-level editing detached from the canvas.

### Element Hierarchy And Text Ownership

Text sections are semantic properties of flow objects rather than a separate document outline. Initial text ownership must support:

| Owner | Text Sections |
|---|---|
| App container | App Synopsis, Major Features, Happy Path Description, Logic Description / Logic Notes |
| Subflow or module container | Description, Logic Notes, Acceptance Criteria |
| Individual node | Notes, Acceptance Criteria |
| Flow view when nothing is selected | View Description, Acceptance Criteria |

Text sections must be saved, reopened, exported, linked to semantic owners, and included in undo/redo history. Text section ownership must survive view switching, document save/reopen, semantic JSON export, and package recovery.

`Logic Description` is the product requirement name from the original PRD. `Logic Notes` is the shorter UI label used in the Unified v2 design documents. They refer to the same app-level text section unless a later schema migration deliberately separates them.

The canonical schema type for this section is `logic_description`. The UI may display `Logic Notes`, but code, JSON, validation, proposal patches, exports, and tests must use `logic_description` as the stable text section type.

### Inspector

The Inspector always reflects the current canvas selection. If nothing is selected, it reflects the active flow view.

View-level properties must have a distinct access path from app-container properties. Clicking inside the app container but not on a child element selects the app container. Deselecting all canvas objects, using a View Properties command, or using an equivalent toolbar/menu action shows view-level properties.

For any selected object, the Inspector must provide a consistent structure where applicable:

- object name and type
- editable object properties
- text section links
- code links
- validation findings relevant to the object
- provenance and source evidence
- acceptance criteria
- proposal impact when a Codex proposal exists
- export inclusion and preview status in Export mode

The Inspector must update when selection changes and must not steal text editing focus from an active text edit or canvas rename operation.

Selection changes may update Inspector content while text editing remains active, but they must not automatically move keyboard focus into the Inspector.

### Traceability Requirements

The product must include traceability through the Inspector and Trace mode. This replaces the original PRD's separate "Traceability Panel" mechanism while preserving the capability.

For generated content, traceability must show:

- source files, modules, docs, or commands used as evidence
- prompt and generation record
- repository scan that supplied the evidence
- whether the object was generated, user-authored, edited, or accepted from a proposal

For user-authored content, traceability must allow manual links to files, modules, symbols, docs, and commands.

### Mode-Driven Context

The primary toolbar modes are:

- Edit: default authoring mode for object properties, text sections, flow views, nodes, connections, layout, and selection.
- Validate: foregrounds lint findings, ambiguity, incomplete paths, and affected canvas objects.
- Trace: foregrounds source links, provenance, generation history, repository evidence, and manual evidence links.
- Review: foregrounds Codex findings and proposals, including current-versus-proposed changes when a proposal exists.
- Export: foregrounds export workflows. Markdown export is the default document-authoring workflow; semantic JSON export is a separate tooling workflow in the same mode.

Modes must share the same document and selection model. Switching modes must not discard user edits, canvas selection, text panel state, or unsaved proposal review state.

Change Impact remains a named workflow requirement and is implemented as a Trace mode subview in Unified v2. It is not a sixth primary toolbar mode. When repository scanning is available, Trace mode must provide a visible Change Impact subview that shows source changes from repository rescans and highlights impacted views or objects. If a later design promotes Change Impact to a primary mode, the toolbar and mode switcher design must be revised deliberately rather than treating the sixth mode as implicit.

### Text Panel

The Text panel opens when the user chooses a text section from the Inspector. If already open, it updates to show the newly chosen section.

The Text panel must support sticky behavior:

- Once opened, it stays open until closed or hidden by the user.
- When selection changes to an object with the same section type, it shows the newly selected object's version of that section.
- When selection changes to an object without that section type, it switches to the first available text section for the new object or closes if none exists.
- Its header must make the section name and owning object clear.

`First available` uses the deterministic section order defined by owner type:

- App container: App Synopsis, Major Features, Happy Path Description, Logic Description.
- Subflow or module container: Description, Logic Description, Acceptance Criteria.
- Individual node: Notes, Acceptance Criteria.
- Flow view: View Description, Acceptance Criteria.

The first available section is the first section type in this order that the selected owner supports, regardless of whether the current body text is empty. Recency and non-empty content must not change this ordering.

Text edits must participate in the same document undo/redo and save lifecycle as canvas edits.

Text editing focus wins over automatic sticky rebinding. While the user is actively typing in the Text panel, passive selection changes, mode changes, or proposal/validation updates must not swap the Text panel to a different owner or section. A user-initiated canvas click may intentionally end text editing, commit the current edit into document undo history, change selection, and then apply sticky behavior. The implementation must make this transition predictable and must not discard typed text.

### Flow Views

Each project flow must support these initial view types:

- App Overview: major app surfaces, modules, services, stores, and integrations.
- Happy Path: primary successful user or system path through the app.
- Component Logic: detailed logic for a module, feature, component, or workflow.
- Failure Path: unhappy paths, retry paths, cancellation, permissions, empty states, and error handling.

The user must be able to create, rename, switch, and delete flow views while preventing deletion of the last useful view. View switching may be exposed through menus, toolbar state, keyboard shortcuts, or another native document command surface; it does not require a permanent sidebar.

Switching views updates the canvas, Inspector, and Text panel to the new view context. View switching must not corrupt unsaved document state.

### Toolbar And Native Command Surfaces

The app must provide native command access for:

- showing and hiding Inspector and Text panels
- switching modes
- zooming out, zooming in, fitting, and resetting view
- showing document lifecycle state
- showing active flow view
- showing current view element count
- opening the AI action surface
- creating, opening, saving, closing, duplicating, reverting, importing, exporting, arranging, formatting, reviewing, and getting help

The exact ordering, labels, icons, and visual treatment are UI design decisions, not PRD requirements.

### Review Notifications

The Review mode notification badge shows the number of unresolved review items that require explicit user disposition.

The badge count must include:

- pending Codex proposals that have not been accepted or rejected
- Codex design review findings that have not been marked reviewed, dismissed, converted to validation findings, or resolved
- proposal conflicts that require user action

The badge must not clear merely because the user opens Review mode. It clears only when each counted item receives an explicit disposition. A reviewed-but-unresolved item may remain visible in Review mode without contributing to the badge if the user explicitly marks it reviewed.

### Local Library

The product must provide local access to:

- Saved Project Flows
- Template Flows

Unified v2 does not require a permanent library sidebar. Saved project flows and template flows may be accessed through native document workflows, File menu actions, open panels, recent documents, or a later library browser, but the underlying local library capability remains required.

### Flowchart Canvas

The first canvas implementation must prioritize structured flowchart objects only. Freehand sketching can be considered later as a separate layer, but it must not dilute the semantic flow model in the first usable product.

The canvas must support:

- standard flow object creation
- element selection, move, resize, rename, and delete
- container selection, move, resize, rename, and delete where valid
- directional connections between flow objects
- connection labels and decision branch labels
- connection routing that can represent retry loops and convergence points
- pan, zoom, fit, and reset view
- undo and redo
- alignment aids such as grid, snap, or guides
- visible validation, traceability, review, and export overlays where mode context requires them

Initial standard flow object types:

Containers:

- app container
- subflow/module container

Elements:

- start/end
- process
- decision
- input/output
- data store
- document
- connector
- actor/system boundary
- retry step
- terminal outcome
- annotation

`Retry step` is a semantic process-like node that represents a step intended to return to an earlier node, decision, or subprocess. It may be visually styled as a warning in the UI, but it is not just a color variant. Validation should warn when a retry step has no outgoing path that rejoins or rechecks the flow.

`Terminal outcome` is a semantic end node with an outcome classification such as success, failure, cancellation, or timeout. A failure end state is a terminal outcome with `outcome = failure`, not a separate visual-only type. Visual encoding remains in the UI and UX design documents.

### Element Creation

Phase 0 must include an explicit flow object creation mechanism: a native toolbar Add Object button that opens a palette of supported flow object types.

The Add Object palette must satisfy these product requirements:

- expose all Phase 0 flow object types
- create the selected type inside the active view and app container
- place the new object at the visible canvas center by default
- support click-to-place before or after type selection before the first usable product is considered complete
- preserve undo/redo for creation
- give the new object a stable ID and editable label
- avoid relying on Codex or templates for basic element creation

Contextual menu and keyboard creation shortcuts are allowed as accelerators, but they do not replace the toolbar Add Object palette for Phase 0.

### Keyboard And Native Editing Basics

The editor should support native macOS editing expectations:

- undo and redo for document, text, canvas, and proposal-application actions
- copy, paste, delete, and duplicate for selected flow objects and compatible text selections
- keyboard shortcuts for zoom in, zoom out, fit to screen, reset zoom, and pan or navigate where appropriate
- save, open, close, duplicate document, revert, and export through native menus and document commands
- predictable first-responder behavior for text editing, canvas shortcuts, menus, toolbar actions, and rename operations
- disabled commands when no valid target exists instead of silent no-ops

### AI Interaction

Codex assistance must be explicit and reviewable.

Initial Codex actions:

- generate a new project flow from prompt
- generate a specific flow view
- modify a selected flow view from instruction
- modify selected objects from instruction
- explain or expand selected elements
- generate app overview from selected existing-app context
- generate component logic from selected files or modules
- suggest missing branches, unclear transitions, failure paths, or implementation risks
- review a flow for missing states, confusing paths, excessive complexity, and implementation risks

AI interactions are tied to current document context: active view, selected objects, related text sections, source links, and relevant semantic model excerpts.

Codex output must validate against the semantic flow schema before it can be applied. Codex proposals must be reviewed before document mutation. The review experience must make additions, removals, and edits clear for diagram structure and linked text sections.

The original PRD's side-by-side diff requirement is preserved as a product requirement: when a proposal exists, Review mode must provide a current-versus-proposed comparison. Unified v2 resolves this as a canvas comparison plus Inspector diff: the canvas distinguishes added, modified, and removed objects, and the Inspector shows the selected object's before/after semantic changes. A side-by-side view may be added later, but Phase 0 and Phase 1 implementation should not depend on a second full canvas.

## Functional Requirements

### Delivery Phasing

The full product vision is broader than the first usable release. Delivery should be phased so each increment proves one value loop before adding the next layer of complexity.

Phase 0, Core Authoring, proves that semantic flow data and native canvas rendering work together reliably:

- create, open, save, and reopen local project flow documents
- render an editable full-canvas workspace
- create and edit an app container
- edit required app-level text sections through object selection
- create and switch between app overview, happy path, component logic, and failure path views
- place and edit initial standard flow object types
- connect elements with labeled directional links
- preserve semantic model and PaperKit data in a package document
- export one implementation-brief Markdown format and semantic JSON

Phase 1, Implementation Readiness, adds quality and planning support:

- deterministic flow validation
- acceptance criteria per node, container, and view
- code links
- bundled templates
- local named snapshots
- richer Markdown export variants
- Codex design review and proposal review for prompt-generated or user-selected context

Phase 2, Existing-App Maintenance, adds source-linked maintenance workflows:

- explicit repository selection and bounded scans
- source evidence capture
- generated views from selected files or modules
- rescan snapshots
- change impact analysis
- proposal updates from source impact

Phase boundaries should guide implementation order and acceptance. Later-phase requirements may be defined in this PRD, but they should not block the first usable Core Authoring release.

### MVP Features

The full MVP feature set includes the base editor plus these implementation-readiness features:

- Flow validation and linting: detect disconnected nodes, decision branches without labels, missing error paths, duplicate concepts, and unclear start/end points.
- Code links: link flow objects to repository files, modules, symbols, docs, or commands.
- Change Impact workflow: when an existing app is rescanned, show what changed since the last accepted scan through the Trace mode Change Impact subview.
- Version history and snapshots: local document versions with named milestones such as "Initial Codex draft", "Post-review", and "Implemented".
- Flow-to-doc export: export Markdown sections for PRDs, architecture docs, handoff docs, README snippets, and implementation briefs.
- Semantic JSON export: export the semantic flow model for tooling, Codex handoff, migration, and structured interchange.
- Design review mode: let Codex critique a flow for missing states, confusing paths, excessive complexity, and implementation risks.
- Failure path views: support separate or overlay views for unhappy paths, retry paths, cancellation, permissions, empty states, and error handling.
- Traceability: show why an object exists, including source files, prompts, scan records, and provenance behind generated content.
- Acceptance criteria per node, container, and view: attach "done when" notes to components, steps, views, or complete flows.

### Project Flow Documents

- Create a new project flow.
- Open an existing project flow.
- Save and reopen local project flows.
- Store document metadata, lifecycle state, text sections, flow views, elements, containers, connections, layout geometry, generation provenance, validation findings, code links, proposals, and snapshots.
- Preserve stable IDs for flow elements, containers, text sections, connections, views, proposals, and evidence records.

### Document Lifecycle

A project flow can move through these product states:

- Draft: user-authored or template-created content is being edited locally.
- Codex proposed: Codex has generated a proposal that has not yet been accepted or rejected.
- User reviewed: the user has reviewed a proposal, validation result, export preview, or scan result.
- Implementation-ready: the flow has enough validated structure, acceptance criteria, and exportable detail to guide implementation.
- Linked to existing app: the document is associated with a selected local repository and source evidence.
- Rescan available: the linked repository has changed since the last accepted scan snapshot.
- Out of sync with source: source-linked flow elements or views are affected by repository changes that have not yet been reviewed.

Lifecycle states should be visible without blocking editing. State changes caused by Codex output, repository scans, or source impact analysis must remain reviewable by the user.

### Semantic Flow Model

- Represent flow objects independently from canvas rendering.
- Represent connections independently from drawn connector strokes.
- Preserve labels, notes, element type, container hierarchy, layout geometry, and view membership.
- Allow generated and user-authored flows to use the same model.
- Store text sections as owned semantic objects linked to app containers, subflow/module containers, individual nodes, and flow views.
- Store acceptance criteria for individual nodes, containers, and views as "done when" notes.
- Store code links from elements and containers to repository files, modules, symbols, docs, or commands.
- Store validation state without treating validation warnings as destructive document changes.

### Draft Semantic Schema

The semantic schema should be explicit before Codex-generated changes can be accepted into documents. The initial schema should include these entities:

- ProjectFlowDocument: stable document ID, title, summary, metadata, lifecycle state, timestamps, text sections, flow views, proposals, snapshots, and optional source-app context.
- TextSection: stable ID, owner type, owner ID, type, title, body text, linked view IDs, linked element IDs, and updated timestamp.
- FlowView: stable ID, type, name, description, root app container ID, object IDs, connection IDs, acceptance criteria IDs, validation finding IDs, active Trace subview when applicable, and view layout metadata.
- FlowElement: stable ID, element type, label, notes, geometry, view membership, parent container ID, acceptance criteria IDs, code link IDs, provenance ID, and type-specific properties.
- FlowContainer: stable ID, container type, label, notes, geometry, parent container ID, child element IDs, text section IDs, acceptance criteria IDs, code link IDs, provenance ID, and view membership.
- FlowConnection: stable ID, source object ID, target object ID, source object type, target object type, direction, label, condition text, relationship type, provenance ID, and optional route/layout metadata.
- AcceptanceCriterion: stable ID, owner type, owner ID, text, status, and updated timestamp.
- CodeLink: stable ID, owner element, container, or view ID, link type, repository path, optional symbol/module/command/doc reference, scan snapshot ID, and display label.
- ValidationFinding: stable ID, rule ID, severity, message, affected view ID, affected element IDs, affected container IDs, affected connection IDs, source type, and dismissed or resolved state.
- Proposal: stable ID, base document revision, source instruction, proposed semantic patch, validation result, conflict state, review state, and provenance records.
- ProvenanceRecord: stable ID, actor type, prompt or user action summary, source files or docs, model/provider when applicable, created timestamp, and superseded-by relationship.
- RepositoryScanSnapshot: stable ID, repository path, Git commit hash when available, include/exclude scope, file records, scan timestamp, and redaction summary.
- DocumentSnapshot: stable ID, name, reason, created timestamp, actor type, semantic document revision, and optional package member references.

Initial schema constraints:

- IDs must remain stable across save, reopen, export, proposal review, and snapshot comparison.
- `FlowElement` and `FlowContainer` share one `FlowObject` ID namespace. A flow object is any selectable semantic object that can appear in a view.
- Containers are flow objects. `app_container` and `subflow_module_container` are container types, not regular element types.
- Connections must reference existing source and target flow objects in the same project flow.
- Connections may target `FlowElement` objects and subflow/module `FlowContainer` objects. Connections must not target the canonical app container unless a later schema version explicitly allows app-to-app composition.
- Flow objects can appear in one or more views, but each view must preserve its own layout geometry.
- The canonical app container appears in every normal project flow view. Its app-level text, code links, provenance, and validation are document-level; its geometry is view-level.
- Text sections must reference valid owners.
- Every flow view must have a valid root app container.
- Every flow view's `root app container ID` must reference the document's canonical app container.
- Decision connections should have branch labels or condition text when they leave a decision element.
- Validation findings must reference affected semantic objects without mutating those objects.
- PaperKit data may cache presentation and interaction details but cannot be the only durable source for flow meaning.

### Flow Validation And Linting

- Deterministically detect disconnected nodes.
- Deterministically detect decision branches without labels.
- Deterministically detect unclear, missing, or multiple unintended start and end points.
- Detect objects outside their required container scope where containment is required.
- Detect text sections with missing or invalid owners.
- Heuristically or Codex-assisted detect missing error paths where a step has likely failure modes.
- Heuristically or Codex-assisted detect duplicate or near-duplicate concepts.
- Surface validation findings without blocking editing.
- Allow findings to link back to the affected node, container, connection, or view.
- Mark heuristic findings as suggestions and keep them reviewable rather than treating them as hard validation failures.

### Acceptance Criteria

- Let the user attach acceptance criteria to a flow view.
- Let the user attach acceptance criteria to a container.
- Let the user attach acceptance criteria to an individual node.
- Preserve acceptance criteria in the semantic document model.
- Include acceptance criteria in exports intended for implementation briefs or handoff docs.

### Canvas Rendering

- Render semantic flow objects into an editable native canvas.
- Keep PaperKit integration behind the adapter target.
- Preserve enough PaperKit markup or rendering data to support native canvas editing.
- Avoid making PaperKit markup the only durable source of flow meaning.
- Treat PaperKit data as package-member rendering data, not as the semantic model.

### PaperKit Assumptions And Risks

The current implementation direction assumes PaperKit is available through the installed macOS SDK and can be isolated behind `FlowDesignPaperKit`.

Before relying on PaperKit for the first usable product, implementation should verify:

- the target SDK exposes the required PaperKit module and runtime APIs
- selection, hit testing, undo/redo, and editing behavior are sufficient for structured flowchart objects
- rendering can support the initial element and container types or can host custom rendering for them
- PaperKit data can be stored and restored as package-member rendering data
- semantic objects can remain the source of truth even when PaperKit interaction data changes

If PaperKit cannot support the required structured editing loop, the fallback should be a custom SwiftUI/AppKit canvas that still preserves the same semantic model and package format.

### User And Codex Authoring Rules

User-authored edits apply directly to the active document through normal document undo/redo.

Codex-authored edits must be represented as proposals before they mutate the active document. Proposal behavior should follow these rules:

- A proposal records the document revision it was generated from.
- If the user edits affected objects while a proposal is pending, the proposal should be marked as needing review or conflict resolution before apply.
- The user can reject the entire proposal.
- The user should be able to accept an entire proposal as one undoable document action.
- Partial acceptance is offered only for independent proposal changes whose dependencies are also accepted or already exist in the active document.
- If a proposed change depends on another proposed change, accepting the dependent change must also accept the prerequisite or block the action with a clear conflict explanation.
- Examples of blocked partial acceptance include accepting a connection while rejecting the proposed source or target object, accepting text for an object that does not exist, or accepting a code link whose owner is rejected.
- Applying a proposal must run semantic schema validation first.
- User edits to Codex-generated objects should preserve provenance by marking the object as generated-then-user-edited rather than losing its history.
- Traceability should show both generated provenance and later user edits when both exist.

### Existing App Flow Generation

- Let the user manually select a repository as the starting context.
- Scan the selected repository to derive candidate files, modules, docs, and app structure.
- Let the user refine which scanned files, folders, or docs are included as generation context.
- Let the user specify the desired view type and prompt.
- Record source context and generation provenance.
- Validate generated flow output before showing it as a proposal.
- Require user acceptance before modifying the active document.

Existing-app analysis is not required for the Phase 0 Core Authoring release. The first existing-app increment may start with user-selected files, a reviewed file list, and high-signal docs rather than a full static-analysis pipeline.

### Repository Scan Rules

Version 1 repository scanning should be explicit, bounded, and inspectable.

Include:

- source files
- README and documentation files
- package manifests and dependency manifests
- project, build, and runtime configuration files
- test files where they explain behavior or acceptance expectations

Exclude:

- dependency folders
- build output folders
- generated artifacts
- cache folders
- binary files unless explicitly selected later
- local secrets, credentials, keys, tokens, and environment files where detectable

Scan snapshots should preserve:

- normalized file paths
- file modification timestamps
- file sizes or content hashes where useful for change detection
- Git commit hash when the selected repository is a Git checkout
- scan timestamp and selected include/exclude scope

The user should be able to review included files before Codex generation starts.

### Change Impact

- Store repository scan snapshots for project flows linked to existing apps.
- Compare a new scan with the previous accepted scan.
- Show changed, added, removed, and potentially impacted files, modules, docs, or commands.
- Highlight flow elements and views whose source evidence changed.
- Let the user ask Codex to propose flow updates from source impact.
- Preserve change impact as reviewable state rather than mutating the flow automatically.

### Templates

- Maintain a local library that includes Saved Project Flows and Template Flows.
- Bundle a starter set of template flows.
- Allow a user to create a new project flow from a template.
- Preserve template provenance in the new document metadata where useful.

Initial template candidates:

- basic app overview
- CRUD app
- document-based macOS app
- import/review/approve workflow
- AI-assisted generation workflow
- background job workflow
- error and retry workflow

### Version History And Snapshots

- Support local document snapshots.
- Let the user name milestones such as "Initial Codex draft", "Post-review", and "Implemented".
- Preserve enough snapshot metadata to understand who or what created the milestone.
- Let the user compare meaningful document versions at the flow/view level.

### Flow-To-Doc Export

- Markdown and semantic JSON are the first MVP export targets.
- Markdown is the first user-facing document export.
- Semantic JSON is the first structured interchange export for the semantic flow model.
- Export Markdown sections for PRDs.
- Export Markdown sections for architecture docs.
- Export Markdown sections for handoff docs.
- Export README snippets.
- Export implementation briefs.
- Include linked acceptance criteria and source evidence where relevant.
- Export semantic JSON for tooling, Codex handoff, migration, and external automation without making the export file replace the native document package as the source of truth.
- Defer image and PDF export until after Markdown and semantic JSON export are reliable.

Export mode must separate Markdown export from semantic JSON export:

- Markdown export is the default Export mode workflow. It includes format selection, inclusion controls, source evidence inclusion, and preview of the generated document structure.
- Semantic JSON export is a tooling workflow. It exports the semantic model and should show schema/version, selected scope, and validation status rather than Markdown document preview.
- Inclusion settings for Markdown must not silently change the semantic JSON export unless the user explicitly chooses a scoped JSON export.
- Both workflows must run validation appropriate to their output before writing files.

The Phase 0 Markdown export should prioritize one implementation-brief format. Additional Markdown export variants should define their own content shape before implementation:

- PRD export should emphasize problem, goals, user stories, requirements, acceptance criteria, and open questions.
- Architecture export should emphasize system components, flow views, dependencies, source evidence, and technical risks.
- Handoff export should emphasize current state, decisions, next steps, risks, and verification evidence.
- README snippet export should emphasize concise product summary, setup-relevant behavior, and usage notes.
- Implementation brief export should emphasize flow steps, acceptance criteria, source links, validation findings, and build-ready tasks.

## AI Requirements

- Use an internal Codex/LLM service boundary rather than scattering provider calls through UI code.
- Let the user select the LLM provider and model through the shared provider registry when AI features are enabled.
- Store prompt definitions as reviewable, versioned assets where practical.
- Prefer structured output for generated flow changes.
- Validate structured output before applying it.
- Provide safe failure states for invalid output, timeout, provider errors, and low-confidence results.
- Preserve provenance for generated content.
- Keep user review as the default gate before document mutation.
- Support a design review mode where Codex critiques a flow for missing states, confusing paths, excessive complexity, and implementation risks.

Minimum AI provider capabilities:

- structured JSON output compatible with the semantic proposal schema
- configurable timeout and retry policy
- enough context capacity for selected prompt, flow summary, and reviewed source excerpts
- model/provider identity available for provenance
- safe error reporting for timeout, invalid output, refusal, rate limit, and provider unavailability

## Privacy And Safety Requirements

- The user must explicitly select any repository or folder before it is scanned.
- The app must show the files selected for generation before sending context to Codex.
- Detectable secrets, local credentials, tokens, keys, environment files, dependency folders, generated artifacts, binaries, and build outputs should be excluded from scan and generation context by default.
- Codex-generated changes must be shown as proposals and require user review before they mutate the document.
- Invalid, partial, timed-out, or low-confidence Codex output must fail into a reviewable safe state rather than changing the active flow.
- Provenance should make it clear whether a flow object was user-authored, generated, edited, accepted from a proposal, or linked to source evidence.

## Data Requirements

The durable document model should include:

- document ID and title
- metadata
- lifecycle state
- text sections with semantic owners
- flow views
- app containers and subflow/module containers
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

The JSON model remains the source of truth for project metadata, lifecycle state, text sections, flow views, containers, elements, connections, layout geometry, and proposal state.

## Error States And Recovery

The app should define safe behavior for expected failure cases:

- Corrupted document package: open a recovery view that reports the unreadable package member, offers read-only metadata where available, and avoids overwriting the original file automatically.
- Semantic JSON and PaperKit data out of sync: prefer semantic JSON as source of truth, regenerate or mark PaperKit rendering data stale, and surface the issue in validation.
- Text section owner missing or invalid: preserve recoverable text as orphaned recovery data, surface the issue in validation, and avoid silently discarding content.
- Offline or unavailable AI provider: keep local editing, validation, save/reopen, and export available; disable or explain Codex actions.
- Linked repository moved, deleted, or inaccessible: keep the document editable, mark source links as unavailable, and offer relink or unlink actions.
- Very large flows: preserve editing and export safety with progressive rendering, search/filter, warnings, or view splitting rather than failing silently.
- Large repository scans: require explicit scope refinement before generation and avoid sending uncontrolled context to Codex.

## Performance And Scale Targets

Initial performance targets should be concrete enough to guide implementation and testing:

- Comfortable editing for at least 100 elements and 150 connections in a single view.
- Project documents with at least 10 flow views should remain navigable without noticeable mode-switch delays.
- Save and reopen should preserve a typical project flow package in under 2 seconds on the target development machine.
- Canvas pan, zoom, selection, and drag interactions should feel interactive at the 100-element target.
- Inspector updates should feel immediate when selection changes.
- Sticky text panel updates should not cause visible document stalls when moving between typical selections.
- Repository scans should present an include/exclude review list before generation and should warn before processing very large file sets.
- Codex proposal generation should show progress, timeout, cancellation, and safe failure states rather than leaving the document in an indeterminate state.

## Platform Requirements

- Native macOS app.
- Swift and SwiftUI app shell.
- AppKit interop for PaperKit surfaces.
- Local-first document behavior.
- Native menus for document, edit, view, arrange, format, review, import, export, window, and help commands.
- Keyboard shortcuts for common editor actions.
- No local server or browser runtime required.

## Quality Requirements

- Build and test from the repo root.
- Keep core flow-model logic in `FlowDesignCore` with automated tests.
- Keep PaperKit-specific behavior isolated in `FlowDesignPaperKit`.
- Keep UI state separate from durable document semantics.
- Add tests for document creation, app container ownership, text section ownership, flow element validation, connection validation, template instantiation, and Codex output validation as those features are introduced.

## First Usable Product Scope

The first useful version should prove the Phase 0 local authoring loop:

1. Create a project flow.
2. Show a full-canvas native workspace.
3. Create and select an app container.
4. Edit app-owned structured text sections through selection and Inspector-driven text access.
5. Switch between app overview, happy path, component logic, and failure path views.
6. Add standard flow objects.
7. Connect elements with labeled directional links.
8. Save and reopen the project flow.
9. Export one implementation-brief Markdown format.
10. Export semantic JSON for structured interchange.
11. Preserve enough package structure for PaperKit rendering data to stay separate from semantic JSON.

The following items are important but should land after the first usable authoring loop unless implementation proves they are trivial to include: templates, full validation/linting, code links, repository scanning, change impact, local named snapshots, Codex proposal review, and Codex design review.

## MVP Acceptance Criteria

The first usable product is acceptable when these conditions are met:

1. Create a project flow is done when a user can create a new local document with default metadata, a root app container, required app-level text sections, and at least one editable flow view.
2. Full-canvas workspace is done when the canvas is the primary editable surface and secondary Inspector/Text surfaces can be shown or hidden without changing document content.
3. App container is done when it can be selected, moved, resized, renamed, saved, reopened, and used as the owner for app-level properties.
4. Edit structured text sections is done when app synopsis, major features, happy path description, and logic notes can be edited, saved, reopened, and linked to their semantic owner.
5. Sticky text access is done when the open text section follows compatible selection changes and clearly identifies the current owning object.
6. Switch between views is done when the user can create, rename, switch, and delete app overview, happy path, component logic, and failure path views while preventing deletion of the last useful view.
7. Add standard flow objects is done when all initial flow object types can be placed, selected, moved, resized, renamed, deleted, and represented in the semantic model.
8. Connect elements is done when directional links can be created between elements, carry labels or decision branch labels, and remain stable after save and reopen.
9. Save and reopen is done when the document package persists semantic JSON and required PaperKit data separately, then restores the same text, views, containers, elements, connections, layout, and IDs.
10. Export is done when the user can export an implementation-brief Markdown document with relevant flow text and flow steps, and can also export semantic JSON containing the flow graph, text sections, view metadata, and stable IDs.
11. PaperKit separation is done when the package keeps semantic JSON independent from rendering data and can recover a useful document from semantic JSON if rendering data is stale or missing.

Phase 1 and Phase 2 acceptance criteria:

- Template creation is done when a user can create a new project flow from at least one bundled template and the new document preserves template provenance.
- Flow linting is done when deterministic findings appear in the Inspector and link back to affected canvas objects; heuristic findings are clearly labeled as suggestions.
- Code links are done when a user can link elements or containers to repository files, modules, symbols, docs, or commands and those links are preserved in the semantic document model.
- Repository scanning is done when a user can select a local repository, review included files, exclude unwanted context, capture a scan snapshot, and preserve source evidence without including detectable secrets by default.
- Change impact is done when a rescan compares against the previous accepted scan and highlights changed, added, removed, and impacted files, views, and objects.
- Local snapshots are done when a user can name a milestone, save a local document snapshot, and compare meaningful document versions at the flow or view level.
- Rich Markdown export is done when PRD, architecture, handoff, README, and implementation-brief exports each have defined content structures and include relevant flow text, acceptance criteria, and source evidence without manual reconstruction.
- Codex proposal review is done when generated changes validate against the semantic schema, show current-versus-proposed impact, preserve user edits, and apply only after explicit user acceptance.
- Codex design review is done when Codex findings for ambiguity, missing states, complex paths, and implementation risks appear in Review mode and link back to affected flow objects or views.

## Success Criteria

- A user can create a 10-node implementation-ready app flow and export an implementation brief in under 30 minutes after first launch.
- A user can select a flow object and understand its text, validation, provenance, code links, and acceptance criteria without leaving the canvas context.
- A Codex proposal can be reviewed, accepted, or rejected without losing user edits.
- Rescanning a linked repository clearly shows source-linked flow impacts.
- Exported Markdown is usable as a PRD or implementation brief without manual reconstruction.
- Exported semantic JSON is usable by Codex or external tooling without scraping canvas markup.
- The app keeps semantic flow meaning separate from PaperKit rendering data throughout editing, validation, proposal review, save, reopen, and export.
- At least 80% of generated proposals in representative evaluation cases validate against the semantic schema without manual repair before review.

## Future Features

- Generated implementation plan: turn an accepted flow into a build plan, task list, or work-order style checklist.
- Import from text: paste a PRD, README, or rough notes and generate a structured starting flow.
- Import from JSON: select a `.json` file and generate a structured starting flow.
- State ownership labels: mark whether a step is user action, UI state, backend state, external service, background job, or AI action.
- Reusable component palette: saved modules like auth flow, import flow, review queue, document save, and AI proposal review.
- User-defined visual themes or element styling once semantic behavior is stable.

## Open Questions

- How much PaperKit data is required for reliable native editing when semantic JSON is the source of truth?
- Should template flows be bundled only, user-editable, or both?
- Which text section types should be required versus optional for subflow containers and individual nodes?
