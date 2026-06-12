# UI Mockup Description: Unified v2 — Top Toolbar with Floating Panels

Reference: `unified-v2-top-toolbar.svg`

## Overview

The mockup shows a full-canvas macOS workspace where the flowchart canvas fills the entire window area below the toolbar. There are no permanent sidebars or docked panels. All secondary surfaces — the Inspector and the Text panel — float over the canvas and can be toggled on or off. The toolbar sits at the top of the window, immediately below the menu bar, and remains fixed as the canvas scrolls.

## Window Chrome

The window uses standard macOS title bar chrome with traffic light controls (close, minimise, zoom) in the top-left corner. The title bar displays the app name and the current document name: "Flow Design — Customer Onboarding Flow".

Below the title bar is a native menu bar with eight menus: Flow Design, File, Edit, View, Arrange, Format, Review, Window, Help.

## Top Toolbar

The toolbar occupies a single horizontal strip between the menu bar and the canvas. It is divided into four groups separated by vertical hairline dividers.

### Panel Toggles (left)

Two square toggle buttons labelled "I" (Inspector) and "T" (Text), followed by the word "Panels" in small muted text. Both toggles are shown in their active state with a blue tinted background. Pressing a toggle shows or hides the corresponding floating panel.

### Mode Switcher (centre)

A segmented control with five modes: Edit, Validate, Trace, Review, Export. The active mode (Edit) is shown with a solid blue fill and white text. Inactive modes appear in grey text on the shared segmented background. The Review segment has an orange notification badge showing "1", indicating a pending Codex proposal awaiting review.

### Zoom Controls (right of centre)

A minus button, a percentage label reading "100%", a plus button, and a "Fit" button. These controls remain in place regardless of canvas scroll position or zoom level.

### Status and AI (far right)

A small orange dot followed by "Draft" indicates the document lifecycle state. A middle dot separator, then "App Overview" shows the currently active flow view. Another separator and "10 elements" reports the element count for the current view. At the far right edge is a solid blue "Ask AI" button.

## Canvas

The canvas fills the entire window below the toolbar, edge to edge. It displays a subtle dot grid pattern as an alignment aid. The canvas supports pan, zoom, and scroll — the toolbar remains fixed at the top while the canvas content moves beneath it.

### App Bounding Box

The flow's app-level container is rendered directly on the canvas as a large rounded rectangle with a light blue fill, a dashed blue border, and rounded corners. A label chip reading "Customer Onboarding" sits at the top-left corner of the bounding box against a white background pill.

In the mockup, the bounding box is shown in its selected state. Selection is indicated by a dashed blue outline surrounding the bounding box and four solid blue square handles at the corners. This selection state is what populates the Inspector panel with app-level properties.

The bounding box is a first-class canvas element. It can be selected, moved, and resized like any other element. It represents the app or flow scope and acts as the container for all flow nodes within it.

### Flowchart Elements

Inside the bounding box, the mockup shows a customer onboarding flow with the following elements and visual treatments:

**Start/End terminals** are rendered as ellipses with a green fill and green border. "Start" appears at the top of the flow. "Onboarded" appears at the bottom as the successful end state. "KYC Rejected" appears as a secondary end state with a red fill and red border, branching off the KYC subprocess.

**Process nodes** are rendered as rounded rectangles with a light blue fill and blue border. The flow contains: Visit Landing Page, Create Account, Complete Profile.

**Decision nodes** are rendered as diamonds with a light amber fill and amber border. The flow contains: Email Verified?, KYC Required?, Approved?

**Subprocess nodes** are rendered as rounded rectangles with a light purple fill and purple border, visually distinguishing them from standard process nodes. The flow contains: KYC Verification, Submit Documents.

**Warning/retry nodes** use the same amber treatment as decisions. Send Reminder is shown as an amber rounded rectangle.

### Connections

Directional connections between elements are rendered as grey lines with arrowhead markers at the target end. Decision branches carry coloured labels: "Yes" in green and "No" in red, positioned near the branch point.

The Send Reminder node connects back to the Email Verified? decision via a right-angle routing path, creating a visible retry loop.

The KYC subprocess branches converge back to the main flow path before reaching the Onboarded terminal. The "No" branch from KYC Required? and the "Yes" branch from Approved? both route into the same convergence point.

## Floating Inspector Panel

The Inspector is a floating panel with a drop shadow, positioned at the right side of the canvas. It has a grey header bar with the title "Inspector" and a collapse control.

The Inspector content is driven by the currently selected canvas element. In the mockup, the app bounding box is selected, so the Inspector shows app-level properties.

### Selected Element Header

The element name "Customer Onboarding" is displayed in bold, followed by the element type "Type: App Container" in smaller muted text.

### Text Sections

Below a horizontal divider, the section heading "TEXT SECTIONS" introduces four clickable rows:

- **App Synopsis** — shown in a highlighted state with a blue-tinted background, blue border, bold text, and a solid blue dot on the right edge. This indicates the text panel is currently open and displaying this section.
- **Major Features** — shown in a neutral state with a grey background. A right-aligned annotation reads "4 items".
- **Happy Path** — neutral state, annotated "6 steps".
- **Logic Notes** — neutral state, annotated with a dash indicating no content yet.

Each row is a clickable link that opens (or switches) the floating Text panel to display that section's content.

### Code Links

The heading "CODE LINKS" introduces a list of linked repository paths: `package.json` and `src/onboarding/`, both styled as blue links. An "+ Add link" action appears below.

### Validation

The heading "VALIDATION" shows two findings:
- An orange dot with "2 warnings in this flow"
- A green dot with "10 elements connected"

### Provenance

The heading "PROVENANCE" shows "User-authored · Jun 10, 2026" in muted text, recording who created the element and when.

## Floating Text Panel

The Text panel is a second floating panel with a drop shadow, positioned to the left of the Inspector. It has a grey header bar displaying the section name "App Synopsis" on the left and the parent element name "Customer Onboarding" on the right as a breadcrumb.

The panel body contains the editable text content for the selected section. In the mockup, the synopsis reads:

> This flow describes the end-to-end customer onboarding process, from initial landing page visit through account creation, email verification, optional KYC compliance check, and profile completion.
>
> It serves as the canonical reference for the signup implementation across web and mobile clients.

Below the text, a horizontal divider separates the content from a linked view indicator: a small blue pill labelled "App Overview" showing which flow view this text section is associated with.

At the bottom, the annotation "Updates with selection" indicates that this panel is sticky — it remains open and automatically updates its content as the user selects different canvas elements.

### Connection to Inspector

A subtle dashed blue connector line is drawn between the Inspector's highlighted "App Synopsis" row and the Text panel, making the relationship between the two panels visually explicit.

## What Is Not Shown

The mockup captures the Edit mode with the app bounding box selected. It does not show:

- The Validate, Trace, Review, or Export mode states and how the Inspector content changes for each.
- The Text panel displaying a node-level section (such as acceptance criteria or logic notes for a specific process node).
- The Codex Review split view with current vs. proposed flow comparison.
- The File menu with view switching (App Overview, Happy Path, Component Logic, Failure Paths).
- Panel repositioning, resizing, or the collapsed state of floating panels.
- The element creation palette or toolbar for placing new flowchart elements.
- Undo/redo controls or keyboard shortcut interactions.
