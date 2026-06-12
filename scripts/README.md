# Scripts

Deterministic project maintenance and verification scripts live here.

- `generate_xcode_project.py`: regenerates `FlowDesign.xcodeproj` from the repo's SwiftPM-friendly source layout.
- `build_and_run.sh`: regenerates the Xcode project, builds `FlowDesign.app`, launches it, and optionally verifies the process with `--verify`.
