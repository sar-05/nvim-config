#!/usr/bin/env bash
set -euo pipefail
#
# Install custom Neovim configuration files

#Check if Neovim is installed
command -v nvim > /dev/null || echo "ERROR: No Neovim installation found" && exit 1

# Check for optional dependencies
dependencies=('yazi' 'tmux' 'kitty')
missing_dependencies=()
for dependency in "${dependencies[@]}"; do
  command -v "$dependency" > /dev/null || missing_dependencies+=("$dependency")
done

# Prompt quiting if missing dependencies
if [[ "${#missing_dependencies}" -ne 0 ]]; then
  echo "WARNING: Missing optional dependencies: ${missing_dependencies[*]}"
  printf "Do you wish to proceed?\n0) Proceed\n1) Abort (recommended)\n"
  read -r proceed
  while [[ "$proceed" != "0" ]]; do
    [[ "$proceed" = "1" ]] && echo "WARNING: installation aborted by the user" && exit 1
    printf "Invalid option. Please choose:\n0) Proceed\n1) Abort (recommended)\n"
    read -r proceed
  done
fi

ln -s ./nvim/ "{$XDG_CONFIG_HOME:-$HOME/.config}" /||
  echo "Unable to symlink config files"
