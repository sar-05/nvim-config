#!/usr/bin/env bash
set -euo pipefail
#
# Install custom Neovim configuration files

# Check if Neovim is installed
if ! command -v nvim > /dev/null; then
    echo "ERROR: No Neovim installation found" >&2
    exit 1
fi

# Check if wget is installed
if ! command -v wget > /dev/null; then
    echo "ERROR: No wget installation found" >&2
    exit 1
fi

# Check for optional dependencies
dependencies=('yazi' 'tmux' 'kitty')
missing_dependencies=()
for dependency in "${dependencies[@]}"; do
    command -v "$dependency" > /dev/null || missing_dependencies+=("$dependency")
done

# Prompt quiting if missing dependencies
if [[ "${#missing_dependencies[@]}" -ne 0 ]]; then
    echo "WARNING: Missing optional dependencies: ${missing_dependencies[*]}"
    printf "Do you wish to proceed?\n0) Proceed\n1) Abort (recommended)\n"
    read -r proceed
    while [[ "$proceed" != "0" ]]; do
        [[ "$proceed" = "1" ]] && echo "WARNING: installation aborted by the user" && exit 1
        printf "Invalid option. Please choose:\n0) Proceed\n1) Abort (recommended)\n"
        read -r proceed
    done
fi

# Create config directory if it doesn't exist
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$config_dir"

# Install nerd Fonts
cwd=$(pwd)
mkdir -p ~/.local/share/fonts
wget -P "${XDG_DATA_HOME:-$HOME/.local/share}/fonts" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip \
&& cd ~/.local/share/fonts \
&& unzip FiraCode.zip \
&& rm FiraCode.zip \
&& fc-cache -fv
cd "$cwd"

# Create symlink
if ln -sfn "$(pwd)/nvim" "$config_dir/nvim"; then
    echo "Successfully linked Neovim configuration to $config_dir/nvim"
else
    echo "ERROR: Unable to symlink config files" >&2
    exit 1
fi
