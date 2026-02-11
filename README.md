# claude-dotfiles

Portable Claude Code configuration — settings, permissions, skills, and status line, managed via symlinks.

## What's included

- **settings.json** — Pre-approved read-only permissions, enabled plugins, MCP servers, and a status line showing model, context usage, token counts, cost, and git info
- **skills/** — Custom skills (e.g. Draw.io diagram generation)
- **setup.sh** — Installer that symlinks everything into `~/.claude`

## Quick start

```bash
git clone https://github.com/ZachariahPang/claude-dotfiles.git
cd claude-dotfiles
./setup.sh
```

The setup script will:

1. Install `jq` if missing (required by the status line)
2. Install Claude Code if missing
3. Create `~/.claude` if needed
4. Symlink `settings.json` and `skills/` into `~/.claude` (backs up existing files first)

## Custom config directory

Set `CLAUDE_CONFIG_DIR` to use a directory other than `~/.claude`:

```bash
CLAUDE_CONFIG_DIR=~/my-claude-config ./setup.sh
```

## Updating

Pull the latest changes — symlinks mean your config stays current:

```bash
cd claude-dotfiles
git pull
```
