#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
DEST="$CURSOR_USER_DIR/keybindings.json"

CLAUDE_SRC="$REPO_DIR/keybindings.json"
CURSOR_SRC="$REPO_DIR/keybindings-cursor.json"

current_mode() {
  if [ ! -L "$DEST" ]; then
    echo "none (not a symlink)"
    return
  fi
  local target
  target="$(readlink "$DEST")"
  case "$target" in
    *keybindings-cursor.json) echo "cursor" ;;
    *keybindings.json)        echo "claude" ;;
    *)                        echo "unknown ($target)" ;;
  esac
}

case "${1:-}" in
  claude)
    rm -f "$DEST"
    ln -s "$CLAUDE_SRC" "$DEST"
    echo "Switched to Claude mode (cmd+L → Claude)"
    ;;
  cursor)
    rm -f "$DEST"
    ln -s "$CURSOR_SRC" "$DEST"
    echo "Switched to Cursor mode (cmd+L → Cursor AI)"
    ;;
  status)
    echo "Current mode: $(current_mode)"
    ;;
  *)
    echo "Usage: toggle.sh {claude|cursor|status}"
    exit 1
    ;;
esac
