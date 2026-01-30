#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

files=(
  settings.json
  keybindings.json
  snippets
)

mkdir -p "$VSCODE_USER_DIR"

for f in "${files[@]}"; do
  src="$REPO_DIR/$f"
  dest="$VSCODE_USER_DIR/$f"

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
  echo "linked $f"
done
