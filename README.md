# claude-dotfiles

Portable Claude Code configuration — settings, permissions, skills, and status line, managed via symlinks.

## What's included

### Claude Code dotfiles (**symlinked** — auto-update with `git pull`)

- **settings.json** — Pre-approved read-only permissions, enabled plugins, MCP servers, and a status line showing model, context usage, token counts, cost, and git info
- **skills/** — Custom skills (e.g. Draw.io diagram generation)

These are **symlinked** into `~/.claude`, so pulling new changes updates them immediately.

### tmux dotfiles (**copied** — not auto-updated)

- **tmux.conf** — Standalone tmux config for remote servers, no plugin manager required

This is **copied** (not symlinked) to `~/.tmux.conf` since remote servers may not have this repo checked out persistently. If `~/.tmux.conf` already exists, setup skips it to avoid overwriting custom server configs.

## Quick start

```bash
git clone https://github.com/ZachariahPang/claude-dotfiles.git
cd claude-dotfiles
./setup.sh
```

The setup script will:

1. Install `jq` if missing (required by the status line)
2. Install `tmux` if missing
3. Install Claude Code if missing
4. Create `~/.claude` if needed
5. **Symlink** `settings.json` and `skills/` into `~/.claude` (backs up existing files first)
6. **Copy** `tmux.conf` to `~/.tmux.conf` (skips if file already exists)

## Custom config directory

Set `CLAUDE_CONFIG_DIR` to use a directory other than `~/.claude`:

```bash
CLAUDE_CONFIG_DIR=~/my-claude-config ./setup.sh
```

## Updating

Pull the latest changes — **symlinked** Claude Code configs stay current automatically:

```bash
cd claude-dotfiles
git pull
```

tmux.conf is **copied**, not symlinked, so to update it on a server re-run setup or copy manually:

```bash
cp tmux.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf
```
