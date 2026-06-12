# Flow Design

Flow Design is a native macOS app scaffold for designing, explaining, and maintaining application flows with standard flowcharts on a PaperKit-backed canvas.

## Stack

- Swift
- SwiftUI
- AppKit interop where PaperKit exposes view controllers
- PaperKit and PencilKit from the macOS 26 SDK
- XCTest for the initial core test target

## Requirements

- macOS SDK 26.5 or newer
- Apple Swift 6.3 or newer

The current local SDK check found `MacOSX26.5.sdk` and Apple Swift 6.3.2.

## Repository Shape

- `Sources/FlowDesignApp`: SwiftUI app shell and command surface
- `Sources/FlowDesignCore`: app domain model and testable non-UI logic
- `Sources/FlowDesignPaperKit`: PaperKit/AppKit/SwiftUI bridge
- `Tests/FlowDesignCoreTests`: XCTest coverage for core behavior
- `Resources`: app assets and preview content for a future Xcode app target
- `docs`: architecture and framework notes
- `scripts`: deterministic project maintenance helpers
- `config`: non-secret project configuration

## Product Definition

- [Product requirements document](docs/prd-unified-v2.md): active PRD for goals, user stories, requirements, AI/provider behavior, data model, MVP scope, and open product questions.
- [Product fundamentals](docs/product-fundamentals.md): intent, core concepts, workspace shape, Codex assistance, library, and first usable product scope.
- [Architecture](docs/architecture.md): target boundaries, PaperKit integration, provider-registry alignment, and verification path.
- [Provider registry alignment review](docs/review/flow-design-provider-registry-alignment.md): review input that the active docs now incorporate for provider-backed AI boundaries.

## Build And Test

```bash
swift build
swift test
```

## App Bundle

This scaffold keeps the source tree package-based so core code can be built and tested immediately. Create an Xcode app project or project-generation step when the bundle, signing, entitlements, document types, and asset catalog settings are ready to be made concrete.
