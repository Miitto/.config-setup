#!/usr/bin/env fish

function install
    if type -q pacman
        sudo pacman -Sy $argv
    else
        sudo apt install -y $argv
    end
end

set CONFIG "$HOME/.config"
set NVIM "$CONFIG/nvim"
set TMUX "$CONFIG/tmux"


function setup_nvim
    if not type -q rg
        install ripgrep
    end

    echo $(ls "$NVIM/lua")

    if not test -d "$NVIM/lua"
        git clone "https://github.com/Miitto/neovim-config.git" "$NVIM"
    end

    if not type -q lazygit
        if type -q pacman
            sudo pacman -S lazygit
        else
            set LAZYGIT_VERSION $(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_$LAZYGIT_VERSION_Linux_x86_64.tar.gz"
            tar xf lazygit.tar.gz lazygit
            sudo install lazygit /usr/local/bin
        end
    end
end

function setup_tmux
    if not type -q tmux
        install tmux
    end

    if not test -d "$HOME/.tmux/plugins/tpm"
        git clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
    end

    if not test -e "$TMUX/tmux.conf"
        git clone "https://github.com/Miitto/tmux-config.git" "$TMUX"
    end
end

setup_nvim
setup_tmux
