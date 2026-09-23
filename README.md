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
stow aerospace ghostty herdr nvim scripts skhd tmux yabai zsh
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
