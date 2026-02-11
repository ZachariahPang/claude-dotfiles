#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "==> Claude Code dotfiles setup"
echo "    Repo: $REPO_DIR"
echo "    Target: $CLAUDE_DIR"
echo

# --- Install jq (required for statusLine) ---
if command -v jq &>/dev/null; then
  echo "==> jq already installed: $(jq --version)"
else
  echo "==> Installing jq..."
  if [[ "$(uname)" == "Darwin" ]]; then
    if command -v brew &>/dev/null; then
      brew install jq
    else
      echo "ERROR: Homebrew not found. Install jq manually: https://jqlang.github.io/jq/download/"
      exit 1
    fi
  else
    if command -v apt-get &>/dev/null; then
      sudo apt-get update && sudo apt-get install -y jq
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y jq
    elif command -v pacman &>/dev/null; then
      sudo pacman -S --noconfirm jq
    elif command -v apk &>/dev/null; then
      sudo apk add jq
    else
      echo "ERROR: No supported package manager found. Install jq manually: https://jqlang.github.io/jq/download/"
      exit 1
    fi
  fi
  echo "    jq installed: $(jq --version)"
fi

# --- Install Claude Code ---
if command -v claude &>/dev/null; then
  echo "==> Claude Code already installed: $(claude --version 2>/dev/null || echo 'unknown version')"
else
  echo "==> Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
  echo "    Claude Code installed"
fi

# --- Create ~/.claude if needed ---
mkdir -p "$CLAUDE_DIR"

# --- Symlink settings.json ---
TARGET="$CLAUDE_DIR/settings.json"
SOURCE="$REPO_DIR/settings.json"

if [ -L "$TARGET" ]; then
  echo "==> settings.json already symlinked"
elif [ -e "$TARGET" ]; then
  echo "==> Backing up existing settings.json -> settings.json.backup"
  mv "$TARGET" "$TARGET.backup"
  ln -s "$SOURCE" "$TARGET"
  echo "    Symlinked settings.json"
else
  ln -s "$SOURCE" "$TARGET"
  echo "==> Symlinked settings.json"
fi

# --- Symlink skills/ ---
TARGET="$CLAUDE_DIR/skills"
SOURCE="$REPO_DIR/skills"

if [ -L "$TARGET" ]; then
  echo "==> skills/ already symlinked"
elif [ -e "$TARGET" ]; then
  echo "==> Backing up existing skills/ -> skills.backup/"
  mv "$TARGET" "$TARGET.backup"
  ln -s "$SOURCE" "$TARGET"
  echo "    Symlinked skills/"
else
  ln -s "$SOURCE" "$TARGET"
  echo "==> Symlinked skills/"
fi

echo
echo "==> Done! Run 'claude' to get started."
