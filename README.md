# dotfiles

zsh (oh-my-zsh), vim, tmux and i3 for a Debian desktop.

    git clone https://github.com/kmi3c/dotfiles ~/dotfiles && bash ~/dotfiles/install.sh

`install.sh` symlinks the files into `$HOME` (existing ones go to `~/.dotfiles-backup-<date>`),
downloads the Polish spell file and installs the vim and tmux plugins. Safe to run again.

## vim

| | |
|---|---|
| colours | monokai-chris |
| `Ctrl+E` / `\e` | NERDTree: toggle / reveal the current file |
| `Ctrl+P` / `\b` / `\g` | fzf: files / buffers / text in files (needs `fzf` and `ripgrep`) |
| `za`, `zR`, `zM` | folding by indent, files open unfolded |
| `F7`, `z=` | spelling pl+en on/off, suggestions |

## tmux

Prefix `Ctrl+A`; `|` and `-` split in the current directory; sessions are saved and restored
(tmux-resurrect + continuum). After the first install: prefix + `I` installs the plugins.

`tmux.sh` opens a few named windows.
