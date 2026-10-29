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
| `:Gblame`, `:Gstatus`, `:Gdiff`, `:Glog` | git through fugitive (old names kept as aliases of `:Git blame`, `:Git`...) |
| `\gs` `\gb` `\gd` `\gc` `\gl` `\gp` `\gr` `\gw` `\gi` | git status, blame, diff, commit, log, push, read, write, add -p |
| `\gg` | gitgutter: changed lines in the sign column on/off |

## tmux

Prefix `Ctrl+A`; `|` and `-` split in the current directory; sessions are saved and restored
(tmux-resurrect + continuum). After the first install: prefix + `I` installs the plugins.

`tmux.sh` opens a few named windows.

## i3

`startup.py` runs once per login: applies the monitor layout saved with arandr
(`~/.screenlayout/i3.sh`, machine-specific, retried while the monitors wake up), sets the
wallpaper (`.fehbg`) and opens the apps on their workspaces:

| left monitor (HDMI-1) | right monitor (VGA-1) |
|---|---|
| 1: kitty + tmux (sessions restored by continuum) | 2: Firefox, the other window |
| 3: Firefox, the work window (GitLab, Slack...) | 4: Thunderbird, started once Proton Mail Bridge listens |
| 6: Joplin | |

| | |
|---|---|
| `Print` / `Shift+Print` | flameshot: select an area / whole screen to `~/Pictures` |
| `$mod+Shift+v` | CopyQ clipboard history |

## kitty, GTK

kitty colours in `current-theme.conf`; GTK 2/3/4 dark (Adwaita-dark, Papirus-Dark icons:
`apt install gnome-themes-extra papirus-icon-theme`).
