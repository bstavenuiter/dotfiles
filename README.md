# dotfiles
Contains my most precious dot files 
[github](https://github.com/b-stavenuiter/dotfiles/blob/master/README.md)

## Install

Managed with [GNU stow](https://www.gnu.org/software/stow/). Each top-level
directory is a package whose contents mirror the tree under `$HOME`, so
`nvim/.config/nvim/init.lua` lands at `~/.config/nvim/init.lua`.

```sh
brew install stow
git clone git@github.com:b-stavenuiter/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
stow aerospace brew ghostty herdr nvim scripts skhd tmux yabai zsh
```

`.stowrc` sets `--target=~`, so no `-t` is needed. Add `-n -v` to any command to
see what it would do first.

| | |
|---|---|
| `stow <pkg>` | link a package into `~` |
| `stow -R <pkg>` | restow, after adding or removing files |
| `stow -D <pkg>` | unlink |

Packages land in more than one place where that makes sense: `scripts` and the
`herdr` binaries go to `~/.local/bin`, which `.zshrc` puts on `PATH`.

## Packages (Homebrew et al.)

`brew/.homebrew/Brewfile` is stowed to `~/.homebrew/Brewfile`, Homebrew's global
Brewfile, so `--global` works from any directory. It records taps, formulae and
casks, and also the global `npm`, `go`, `cargo` and `uv` packages — which is
where the language servers live, since nvim installs none itself.

```sh
brew bundle install --global                  # new machine: install everything
brew bundle dump   --global --force           # after installing something: refresh
brew bundle check  --global --no-upgrade      # is the machine in sync?
```

Abbreviated as `bbi`, `bbd` and `bbc`.

`--no-upgrade` on `check` matters: without it, anything merely *outdated* is
reported as unmet, which buries the packages that are genuinely missing.

`dump --force` overwrites in place and follows the symlink, so it writes
straight into this repo.

### Notes

- Stow does not read `.gitignore`. Anything sitting in a package gets linked,
  `.DS_Store` included, so keep the tree clean.
- A `.stow-local-ignore` **replaces** stow's built-in ignore list rather than
  extending it. `herdr/` has one, holding only `commands` — `herdr-commands`
  resolves its own symlink back to this repo to find that directory, so it must
  not be linked into `~/.local/bin`.
- `~/.config/herdr/` holds live runtime state (sockets, logs, installed
  plugins) alongside the tracked config. Because the directory already exists,
  stow descends into it and links individual files instead of folding the whole
  tree — which is what you want. Don't let it fold.
- Homebrew's `--global` path is `$HOMEBREW_BUNDLE_FILE_GLOBAL`, else
  `$XDG_CONFIG_HOME/homebrew/Brewfile`, else `~/.homebrew/Brewfile`, else
  `~/.Brewfile`. Neither variable is set here, hence `~/.homebrew/Brewfile`.
  Setting `XDG_CONFIG_HOME` later would move the target out from under the
  stow link.
- `~/.homebrew/` also holds Homebrew's own `trust.json`, so stow links the
  Brewfile individually rather than folding the directory.
