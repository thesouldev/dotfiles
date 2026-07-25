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
