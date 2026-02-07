#!/usr/bin/env bash

die() {
    echo "Error: $1"
    exit 1
}

# Where to install neovim config
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${NVIM_APPNAME:=nvim}"
CONFIG_DIR="$XDG_CONFIG_HOME/$NVIM_APPNAME/"

# Target distro
DISTRO=$(grep -ioP '^ID=\K.+' /etc/os-release)

copy-configs() {
    # Copy config as is
    rsync -a ./nvim/ "$CONFIG_DIR"

    # Bootstrap lazy-nvim
    echo "$(python ./codegen/gen-plugins.py)" > "${CONFIG_DIR}/lua/plug-gen.lua"
    cp ./codegen/lazy-bootstrap.lua "${CONFIG_DIR}/lua/config/lazy.lua"
    sed -i "1s/^/require'config.lazy'\n/" "${CONFIG_DIR}/init.lua"

    # Remove nix only config
    find "$CONFIG_DIR" -type f -name "*.lua" -exec sed -i '/-- NIX$/d' {} +
}

if [[ -d "$CONFIG_DIR" ]]; then
    rm -fr "$CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
else
    mkdir -p "$CONFIG_DIR"
fi

echo "$0: installing needed packages..."
case "$DISTRO" in
    arch)
        sudo pacman -S --quiet --needed \
            neovim \
            base-devel \
            python \
            xclip wl-clipboard \
            ripgrep fd yazi
        ;;
    *)
        die "unsupported distro"
        ;;
esac

printf '\n%s: copying config...\n' "$0"
copy-configs
