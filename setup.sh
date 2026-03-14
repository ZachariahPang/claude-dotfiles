#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

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
    SUDO=""
    if [ "$(id -u)" -ne 0 ]; then
      SUDO="sudo"
    fi
    if command -v apt-get &>/dev/null; then
      $SUDO apt-get update && $SUDO apt-get install -y jq
    elif command -v dnf &>/dev/null; then
      $SUDO dnf install -y jq
    elif command -v pacman &>/dev/null; then
      $SUDO pacman -S --noconfirm jq
    elif command -v apk &>/dev/null; then
      $SUDO apk add jq
    else
      echo "ERROR: No supported package manager found. Install jq manually: https://jqlang.github.io/jq/download/"
      exit 1
    fi
  fi
  if command -v jq &>/dev/null; then
    echo "    jq installed: $(jq --version)"
  else
    echo "ERROR: jq installation failed"
    exit 1
  fi
fi

# --- Install tmux ---
if command -v tmux &>/dev/null; then
  echo "==> tmux already installed: $(tmux -V)"
else
  echo "==> Installing tmux..."
  if [[ "$(uname)" == "Darwin" ]]; then
    if command -v brew &>/dev/null; then
      brew install tmux
    else
      echo "ERROR: Homebrew not found. Install tmux manually."
      exit 1
    fi
  else
    SUDO=""
    if [ "$(id -u)" -ne 0 ]; then
      SUDO="sudo"
    fi
    if command -v apt-get &>/dev/null; then
      $SUDO apt-get update && $SUDO apt-get install -y tmux
    elif command -v dnf &>/dev/null; then
      $SUDO dnf install -y tmux
    elif command -v pacman &>/dev/null; then
      $SUDO pacman -S --noconfirm tmux
    elif command -v apk &>/dev/null; then
      $SUDO apk add tmux
    else
      echo "ERROR: No supported package manager found. Install tmux manually."
      exit 1
    fi
  fi
  if command -v tmux &>/dev/null; then
    echo "    tmux installed: $(tmux -V)"
  else
    echo "ERROR: tmux installation failed"
    exit 1
  fi
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

# --- Symlink CLAUDE.md ---
TARGET="$CLAUDE_DIR/CLAUDE.md"
SOURCE="$REPO_DIR/CLAUDE.md"

if [ -L "$TARGET" ]; then
  echo "==> CLAUDE.md already symlinked"
elif [ -e "$TARGET" ]; then
  echo "==> Backing up existing CLAUDE.md -> CLAUDE.md.backup"
  mv "$TARGET" "$TARGET.backup"
  ln -s "$SOURCE" "$TARGET"
  echo "    Symlinked CLAUDE.md"
else
  ln -s "$SOURCE" "$TARGET"
  echo "==> Symlinked CLAUDE.md"
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

# --- Copy tmux.conf (skip if already exists) ---
TARGET="$HOME/.tmux.conf"
SOURCE="$REPO_DIR/tmux.conf"

if [ -e "$TARGET" ]; then
  echo "==> ~/.tmux.conf already exists, not updating"
else
  cp "$SOURCE" "$TARGET"
  echo "==> Copied tmux.conf to ~/.tmux.conf"
fi

echo
echo "==> Done! Run 'claude' to get started."
