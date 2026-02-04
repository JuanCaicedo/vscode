#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"

TARGET_DIR="$VSCODE_USER_DIR"

if [ "${1:-}" = "--cursor" ]; then
  TARGET_DIR="$CURSOR_USER_DIR"
fi

files=(
  settings.json
  keybindings.json
  snippets
)

mkdir -p "$TARGET_DIR"

for f in "${files[@]}"; do
  src="$REPO_DIR/$f"
  dest="$TARGET_DIR/$f"

  if [ ! -e "$src" ]; then
    echo "skipping $f (not found in repo)"
    continue
  fi

  if [ -L "$dest" ]; then
    echo "skipping $f (symlink already exists)"
    continue
  fi

  if [ -e "$dest" ]; then
    echo "backing up existing $f to $dest.bak"
    mv "$dest" "$dest.bak"
  fi

  ln -s "$src" "$dest"
  echo "linked $f → $dest"
done
