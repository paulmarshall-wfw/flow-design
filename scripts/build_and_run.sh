#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_PATH="$ROOT_DIR/FlowDesign.xcodeproj"
DERIVED_DATA_PATH="$ROOT_DIR/.build/XcodeDerivedData"
APP_PATH="$DERIVED_DATA_PATH/Build/Products/Debug/FlowDesign.app"
PROCESS_NAME="FlowDesign"

VERIFY=0

for arg in "$@"; do
  case "$arg" in
    --verify)
      VERIFY=1
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 2
      ;;
  esac
done

cd "$ROOT_DIR"

python3 scripts/generate_xcode_project.py >/dev/null

if pgrep -x "$PROCESS_NAME" >/dev/null 2>&1; then
  osascript -e 'tell application "FlowDesign" to quit' >/dev/null 2>&1 || true
  sleep 1
fi

xcodebuild \
  -project "$PROJECT_PATH" \
  -scheme FlowDesign \
  -configuration Debug \
  -destination 'platform=macOS' \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  CODE_SIGNING_ALLOWED=NO \
  build

open -n "$APP_PATH"

if [[ "$VERIFY" -eq 1 ]]; then
  for _ in {1..20}; do
    if pgrep -x "$PROCESS_NAME" >/dev/null 2>&1; then
      echo "Verified $PROCESS_NAME is running from $APP_PATH"
      exit 0
    fi
    sleep 0.5
  done

  echo "Failed to verify $PROCESS_NAME is running" >&2
  exit 1
fi
