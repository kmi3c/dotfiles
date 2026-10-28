#!/bin/bash
# Links the dotfiles into $HOME. Existing files are moved to ~/.dotfiles-backup-<date>
# first, so nothing is lost; running it again changes nothing.
#   bash install.sh
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"
REPO=$PWD
BACKUP=$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)
FILES=(.vimrc .vim/colors/monokai-chris.vim .tmux.conf .zshrc .config/i3/config .config/i3/startup.py
       .config/kitty/kitty.conf .config/kitty/current-theme.conf
       .config/gtk-3.0/settings.ini .config/gtk-4.0/settings.ini .gtkrc-2.0 .fehbg)

for f in "${FILES[@]}"; do
    dst=$HOME/$f
    [ "$(readlink -f "$dst" 2>/dev/null)" = "$REPO/$f" ] && continue
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mkdir -p "$BACKUP/$(dirname "$f")"
        mv "$dst" "$BACKUP/$f"
        echo "backup: $dst -> $BACKUP/$f"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$REPO/$f" "$dst"
    echo "link:   $dst"
done

# vim: Polish spelling (vim ships English only), then the plugins (vim-plug installs itself)
spell=$HOME/.vim/spell/pl.utf-8.spl
if [ ! -s "$spell" ]; then
    mkdir -p "$(dirname "$spell")"
    curl -fsSLo "$spell" https://ftp.nluug.nl/pub/vim/runtime/spell/pl.utf-8.spl && echo "spell:  pl"
fi
vim -E -s -u "$HOME/.vimrc" -c 'PlugInstall --sync' -c 'qa!' >/dev/null 2>&1 || true
echo "vim:    plugins in ~/.vim/plugged"

# tmux: plugin manager; prefix + I inside tmux installs the plugins from .tmux.conf
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone -q https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" && echo "tmux:   tpm (then prefix + I)"
fi

command -v fzf >/dev/null && command -v rg >/dev/null \
    || echo "note:   Ctrl+P / \\g in vim need fzf and ripgrep: sudo apt install fzf ripgrep"
