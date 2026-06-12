# UX Design: Flow Design

## Design Principles

Three principles shape the interaction model:

1. **The canvas is the single workspace.** Everything the user works with — the app structure, flow nodes, connections, text sections, and containers — lives on the canvas as selectable, editable elements. Secondary surfaces float over the canvas; they never displace it.

2. **Select to inspect.** The Inspector is the consistent entry point for understanding and editing any element's properties. What the Inspector shows depends on what is selected on the canvas and which mode is active. There is one interaction pattern for everything: select it, then read or edit its properties.

3. **Modes reshape context, not layout.** Switching between Edit, Validate, Trace, Review, and Export changes what the Inspector displays for the current selection. It does not rearrange the workspace, hide the canvas, or force navigation to a different screen.

## Workspace Structure

### Canvas

The canvas fills the entire window below the toolbar. It scrolls, pans, and zooms independently. All flow content — containers, nodes, connections, labels — is placed directly on the canvas.

A dot grid provides alignment reference. Snap-to-grid and alignment guides assist element placement without constraining it.

### Toolbar

A single toolbar strip sits between the menu bar and the canvas. It contains, left to right:

- Panel toggle buttons for showing and hiding the Inspector and Text panels
- The mode switcher as a segmented control
- Zoom controls (minus, percentage, plus, fit)
- Document status (lifecycle state, active view name, element count)
- The AI action button

The toolbar remains fixed at the top of the window. It does not scroll with the canvas.

### Floating Panels

Two floating panels sit over the canvas:

- **Inspector** — shows properties, text section links, code links, validation findings, and provenance for the currently selected element. Contextually adapts based on the active mode.
- **Text** — shows the editable content of a specific text section. Opens when the user clicks a text section row in the Inspector. Stays open and follows selection (sticky behaviour).

Both panels have a header bar with a title, contextual breadcrumb, and collapse control. Both can be toggled from the toolbar. Both cast a drop shadow to visually separate them from the canvas beneath.

### Menu Bar

The native menu bar provides access to document operations, editing commands, view switching, arrangement tools, formatting, review actions, and help. Flow views (App Overview, Happy Path, Component Logic, Failure Paths) are accessed through the File or View menu rather than through a dedicated sidebar panel.

## The App Container

The app or flow itself is represented on the canvas as a bounding box — a large, labelled, rounded rectangle with a dashed border. This is a selectable, moveable, resizable canvas element.

The bounding box serves three purposes:

1. **Spatial container.** All flow nodes for the current view sit inside it. The bounding box makes the scope of the flow visually explicit.
2. **Selection target for app-level properties.** When the user selects the bounding box, the Inspector shows app-level information: the app synopsis, major features, happy path description, logic notes, app-level code links, and app-level validation.
3. **Hierarchy anchor.** The bounding box establishes the top level of a containment hierarchy. Subflow or module containers can nest inside it, each carrying their own text properties.

## Element Hierarchy and Text Ownership

Text sections are not a standalone panel with their own navigation. They are properties of canvas elements at different levels of the hierarchy:

| Canvas Element | Text Sections Available |
|---|---|
| App bounding box | App Synopsis, Major Features, Happy Path, Logic Notes |
| Subflow/module container | Description, Logic Notes, Acceptance Criteria |
| Individual node | Notes, Acceptance Criteria |
| Flow view (when nothing is selected) | View Description, Acceptance Criteria |

The user accesses text by selecting the relevant canvas element and clicking the text section row in the Inspector. The Text panel opens (or updates) to show that section's content.

This means the relationship between prose and diagram is always spatial and direct. The user does not need to remember which text section describes which part of the flow — they select the part they care about and its text is right there.

## Inspector Behaviour

### Selection-Driven Content

The Inspector always reflects the current canvas selection. When the selection changes, the Inspector updates immediately. If nothing is selected, the Inspector shows view-level properties.

For any selected element, the Inspector shows a consistent structure:

- Element name and type
- Text section links (where applicable)
- Code links
- Validation findings relevant to this element
- Provenance (who created it, when, how)
- Acceptance criteria (where applicable)

### Mode-Driven Context

The Inspector's emphasis shifts depending on the active mode:

- **Edit mode** — full property editing. Text sections, code links, acceptance criteria, and notes are all editable. Validation appears as a summary.
- **Validate mode** — validation findings are promoted to the top of the Inspector. Findings link to affected elements on the canvas. The user can click a finding to select and navigate to the affected element.
- **Trace mode** — provenance and source evidence are promoted. For generated elements: the prompt, source files, scan record, and generation history. For user-authored elements: manual source links and edit history.
- **Review mode** — Codex proposal details are promoted. When a proposal exists, the Inspector shows what would change for the selected element: additions, modifications, removals. The canvas shows current vs proposed state.
- **Export mode** — export inclusion and preview information are promoted. The user can see which elements and text sections will be included in the export and preview the output structure.

Switching modes does not discard edits, deselect elements, or close open panels.

## Text Panel Behaviour

### Opening

The Text panel opens when the user clicks a text section row in the Inspector. If the panel is already open, it updates to show the newly clicked section. Only one text section is displayed at a time.

### Sticky Behaviour

Once open, the Text panel stays open. When the user selects a different canvas element, the panel updates automatically:

- If the new element has a text section of the same type (for example, both the app container and a subflow container have a "Logic Notes" section), the panel shows the new element's version of that section.
- If the new element does not have a matching section, the panel switches to show the first available text section for the new element, or closes if the new element has no text sections.

This avoids the friction of opening and closing the text panel repeatedly as the user navigates the flow.

### Breadcrumb

The Text panel header shows the section name on the left and the owning element name on the right. This breadcrumb ensures the user always knows which element's text they are reading, even when the text panel updates automatically.

### Editing

Text is edited directly in the panel. Edits are part of the document's undo/redo history. The text panel respects the same save and document lifecycle as all other document content.

## Flow Views

A project flow supports multiple views: App Overview, Happy Path, Component Logic, and Failure Paths. Each view is a different perspective on the same underlying flow, potentially showing different elements, connections, and layout.

Views are switched through the menu bar (File or View menu). The currently active view name is displayed in the toolbar status area so the user always knows which view they are editing.

Creating, renaming, and deleting views is available through the menu. The app prevents deletion of the last remaining view.

When the user switches views, the canvas updates to show that view's elements and layout. The Inspector and Text panel update to reflect the new view context. Element selection is cleared on view switch.

## Mode Details

### Edit Mode

The default mode. The canvas is fully interactive: elements can be created, selected, moved, resized, renamed, connected, and deleted. The Inspector shows full property editing. The Text panel is available for any element with text sections.

New elements are placed on the canvas through a creation mechanism (palette, toolbar, contextual menu, or keyboard shortcut — the specific interaction is not prescribed by this design). Connections are drawn between elements by dragging from a source to a target.

### Validate Mode

The canvas remains interactive but the Inspector foregrounds validation findings. Findings are listed by severity and type: disconnected nodes, unlabelled decision branches, missing error paths, duplicate concepts, unclear start/end points.

Each finding links to the affected element or connection on the canvas. Clicking a finding selects and scrolls to the affected object. The canvas may highlight affected elements with a validation overlay (colour tint or icon badge) so the user can see the spatial distribution of issues.

### Trace Mode

The Inspector foregrounds provenance and source evidence. For each selected element, the user can see:

- Whether it was user-authored, generated by Codex, edited after generation, or accepted from a proposal
- The prompt or instruction that generated it (if applicable)
- Source files, modules, or docs linked as evidence
- The repository scan that supplied evidence (if applicable)
- Edit history showing when and how the element changed

For user-authored elements, this mode makes it easy to add manual source links to files, modules, symbols, or documentation.

### Review Mode

This mode activates when a Codex proposal exists. The Inspector shows proposal details for the selected element: what would be added, changed, or removed.

The canvas shows a current vs proposed comparison. Proposed additions, modifications, and deletions are visually distinguished on the canvas (for example, green outlines for additions, amber for modifications, red for removals).

The user can accept or reject the proposal from this mode. Partial acceptance — accepting some changes but not others — is available when the proposal contains separable changes.

If no proposal exists, Review mode shows a prompt to request a Codex review or generate a proposal.

### Export Mode

The Inspector shows export configuration: which Markdown format is selected (implementation brief, PRD, architecture doc, handoff doc, README snippet), which elements and text sections will be included, and a preview of the output structure.

The canvas may dim elements that are excluded from the current export to give the user a visual sense of what will be covered.

The user triggers the export action from this mode. Semantic JSON export is available as a separate action.

## AI Interaction

The "Ask AI" button in the toolbar opens an AI interaction surface — a floating panel, sheet, or popover — where the user can:

- Type a prompt to generate a new flow or flow view
- Request modifications to the current selection
- Ask for explanation or expansion of selected elements
- Request a design review of the current flow
- Request flow generation from selected source files or modules

All AI output is presented as a proposal that the user reviews before it modifies the document. The Review mode activates automatically when a proposal is ready.

AI interactions are tied to the current document context: the active view, the selected elements, and the text sections. The user does not need to re-explain the context — the AI can see the semantic model.

Provider readiness is native and document-centered. The toolbar/menu command, AI setup sheet, Preferences pane, or Inspector action should expose disabled states and concrete readiness reasons when the selected provider profile is missing, unavailable, or not capable of the requested task.

The registry console, if useful for developer setup, remains a separate service UI. It is not embedded in Flow Design's document workflow.

If the saved provider profile is unavailable, the AI surface should keep that saved choice visible, explain that setup is blocked, and ask the user to choose a valid profile. It must not silently switch to a different provider. Local authoring, save/reopen, validation, and export commands remain available while provider-backed AI actions are disabled.

Provider-backed output appears only as Review mode records: proposals, design findings, source-impact findings, or explanations. Accepting generated changes remains an explicit user action and participates in normal document undo/redo.

## Document Lifecycle Visibility

The document lifecycle state (Draft, Codex Proposed, User Reviewed, Implementation-Ready, etc.) is shown in the toolbar status area as a coloured dot and label. State transitions happen as a result of user actions (reviewing a proposal, completing acceptance criteria, linking to a repository) and are visible without blocking editing.

## Keyboard and Native Editing

Standard macOS editing conventions apply throughout:

- Undo/redo operates on a single document history covering canvas edits, text edits, and proposal applications
- Copy, paste, delete, and duplicate work on selected flow elements and text selections
- Zoom keyboard shortcuts (Cmd+Plus, Cmd+Minus, Cmd+0 for fit) work regardless of which panel has focus
- Save, open, close, and export are available through standard menu commands and keyboard shortcuts
- The Inspector follows selection focus without stealing typing focus from the Text panel or an active element rename on the canvas

---

## Departures From and Extensions Beyond the PRD

The following aspects of this UX design differ from or extend beyond what the PRD describes. These are design decisions made in response to the PRD's goals rather than contradictions of its requirements.

### Text Sections as Element Properties, Not a Standalone Panel

The PRD describes a "structured text panel" as a named workspace region — a persistent panel alongside the canvas that contains the four text sections (App Synopsis, Major Features, Happy Path Description, Logic Description). The PRD lists it as a peer of the canvas, library sidebar, and inspector in the workspace layout.

This design replaces the standalone text panel with text sections as properties of canvas elements, accessed through the Inspector and displayed in a sticky floating panel. The PRD's requirement that "text should be linkable to flow views and selected flow elements" is preserved, but the mechanism is inverted: instead of text being a separate surface that links to elements, text belongs to elements and is accessed by selecting them.

This change is motivated by the PRD's own goal that "prose and diagrams stay aligned." Making text a property of the element it describes creates alignment by construction rather than by manual linking.

### The App Bounding Box

The PRD does not describe the app or flow itself as a visible canvas element. The mockup introduces a bounding box — a dashed-border container that represents the app scope on the canvas.

This addresses several PRD requirements through a single interaction pattern: app-level text sections have a natural home (the bounding box's properties), the spatial scope of a flow view is visually explicit, and the hierarchy from app to subflow to node maps onto a containment model that users can see.

The bounding box also provides a clear selection target for app-level properties that would otherwise need a special "nothing selected" state in the Inspector.

### No Sidebar Panels

The PRD describes a workspace with "project/library sidebar" and "structured text panel" as named regions alongside the canvas. This design removes all permanent sidebars.

- The library (saved project flows and templates) moves to the File menu and document-open workflows. Opening a template is a document creation action, not a sidebar interaction.
- The flow view list moves to the File or View menu. The active view name is visible in the toolbar.
- The text panel becomes a floating panel opened from the Inspector.
- The Inspector itself is a floating panel rather than a docked region.

This gives the canvas the maximum possible area. The PRD states "the canvas is the primary work surface" and "text, library, and inspector surfaces support the canvas rather than displacing it." Floating panels over a full-bleed canvas is the most literal interpretation of that directive.

### Views in the Menu Bar, Not a Panel

The PRD describes flow views as requiring a UI for "create, rename, switch, and delete." The PRD's workspace layout includes view switching as part of the sidebar or flow tree.

This design moves view management entirely into the menu bar. The active view is always visible in the toolbar status area. Switching views is a menu action or keyboard shortcut, not a sidebar click. This treats view switching as navigation (like switching tabs in a document) rather than as a panel selection, and avoids dedicating permanent screen space to a short list.

### Sticky Text Panel Behaviour

The PRD does not specify how the text panel should respond to selection changes. It says text should be "linkable to flow views and selected flow elements" but does not describe automatic panel updating.

This design introduces sticky behaviour: the text panel stays open and automatically updates its content when the user selects a different canvas element. This reduces the interaction cost of moving between elements while reading or editing their text. The breadcrumb in the panel header ensures the user always knows which element owns the currently displayed text.

### Inspector Content Driven by Mode

The PRD defines modes (Edit, Validate, Trace, Review, Export) and states that "modes should share the same document and selection model." It describes each mode's focus but does not specify how the Inspector adapts.

This design makes the mode switcher directly control what the Inspector emphasises. In Edit mode, properties are editable. In Validate mode, findings are promoted. In Trace mode, provenance is promoted. The underlying data is the same — the mode determines which sections are foregrounded and which are collapsed or secondary.

This avoids the need for separate validation panels, traceability panels, or review panels. The Inspector is always the Inspector; the mode tells it what to show first.

### Notification Badge on Review Mode

The PRD describes Codex proposals as requiring review but does not specify how the user is notified that a proposal is waiting. This design adds a numbered badge to the Review segment of the mode switcher, making pending proposals visible at all times without interrupting the current mode.

### Element Type Visual Encoding on Canvas

The PRD lists the initial element types and their semantic roles but does not prescribe how they should be visually distinguished on the canvas. This design uses consistent colour coding:

- Green for start/end terminals
- Blue for process nodes
- Amber for decision diamonds and warning/retry states
- Purple for subprocess/module containers
- Red for failure end states

This colour system helps the user read the flow structure at a glance and maps naturally to the validation and review overlays in other modes.
