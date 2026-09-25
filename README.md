# dotfiles

## Setup on a new machine

```sh
git clone git@github.com:thesouldev/dotfiles.git ~/Projects/dotfiles
~/Projects/dotfiles/scripts/install.sh
```

The install script symlinks each config into place, backing up anything already
there as `<file>.bak`. Re-running it is safe.

## What's here

| Path | Links to |
| --- | --- |
| `herdr/config.toml` | `~/.config/herdr/config.toml` |
| `git/hooks/` | `~/.githooks` (global `core.hooksPath`) |

## herdr

Only `config.toml` is tracked. The rest of `~/.config/herdr/` is runtime state
that should not be copied between machines — `session.json` holds open
workspaces and panes, `*.log` are logs, `*.sock` are live IPC sockets.

Since the config is symlinked, editing it on any machine edits the repo. Commit
and push to share the change.

If herdr ever rewrites the config itself (theme change from the settings UI, for
example) it may replace the symlink with a regular file. Check with
`ls -l ~/.config/herdr/config.toml` — if it's no longer a symlink, copy it back
into the repo and re-run `scripts/install.sh`.

## git hooks

`scripts/install.sh` links `git/hooks/` to `~/.githooks` and sets
`git config --global core.hooksPath ~/.githooks`, so every repo on the machine
uses them with no per-repo step.

`commit-msg` rejects a message unless it is:

- a single line
- all lowercase
- at most 72 chars (override with `COMMIT_MSG_MAXLEN`)
- free of AI attribution (claude, anthropic, co-authored-by, generated with, 🤖)
- authored by `hooks.author`, when that is set
  (`git config --global hooks.author thesouldev`)

Git-generated messages (`Merge `, `Revert `, `fixup! `, `squash! `, `amend! `)
skip the style checks but not the attribution check.

Caveats:

- A global `core.hooksPath` disables `.git/hooks`. `commit-msg` still runs the
  repo's own `.git/hooks/commit-msg` afterwards; other hook names need their own
  file here.
- A repo that sets its own `core.hooksPath` (husky, for example) overrides the
  global one, so these hooks do not run there.
- Bypass once with `git commit --no-verify`.
