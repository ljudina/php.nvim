#!/bin/bash

set -e

# Ensure the script is run as root or with sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo." >&2
    exit 1
fi

# Detect original user's home directory (for sudo)
if [[ -n "$SUDO_USER" ]]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
else
    USER_HOME="$HOME"
fi

# Configuration
NVIM_BIN="/opt/nvim/bin/nvim"
NVIM_DIR="/opt/nvim/"
NVIM_ASSET="nvim-linux-x86_64.tar.gz"
LATEST_RELEASE_URL="https://github.com/neovim/neovim/releases/latest"
LATEST_DOWNLOAD_URL="https://github.com/neovim/neovim/releases/latest/download/$NVIM_ASSET"
NVIM_LOCAL_SHARE="$USER_HOME/.local/share/nvim"

get_installed_version() {
    if [[ -x "$NVIM_BIN" ]]; then
        "$NVIM_BIN" --version | head -n 1 | awk '{print $2}'
    else
        echo "0.0.0"
    fi
}

get_latest_version() {
    local final_url version

    final_url=$(curl -sLI -o /dev/null -w '%{url_effective}' "$LATEST_RELEASE_URL") || {
        echo "❌ Failed to reach $LATEST_RELEASE_URL" >&2
        return 1
    }

    # Expected: https://github.com/neovim/neovim/releases/tag/vX.Y.Z
    version="${final_url##*/tag/}"

    if [[ -z "$version" || "$version" == "$final_url" ]]; then
        echo "❌ Could not parse version from redirect URL: $final_url" >&2
        return 1
    fi

    echo "$version"
}

clear_nvim_local_share() {
    if [[ -d "$NVIM_LOCAL_SHARE" ]]; then
        echo "Clearing $NVIM_LOCAL_SHARE..."
        rm -rf "$NVIM_LOCAL_SHARE"
        echo "$NVIM_LOCAL_SHARE has been cleared."
    else
        echo "$NVIM_LOCAL_SHARE does not exist, skipping."
    fi
}

install_latest_version() {
    local version="$1"
    local download_url="$2"
    local temp_dir

    echo "Download URL: $download_url"

    echo "Downloading Neovim $version..."
    temp_dir=$(mktemp -d)
    curl -L "$download_url" -o "$temp_dir/nvim-linux64.tar.gz"

    echo "Extracting Neovim..."
    tar -xzf "$temp_dir/nvim-linux64.tar.gz" -C "$temp_dir"

    echo "Replacing the current Neovim installation..."
    rm -rf "$NVIM_DIR"
    mv "$temp_dir/nvim-linux-x86_64" "$NVIM_DIR"

    echo "Cleaning up..."
    rm -rf "$temp_dir"

    echo "Clearing Neovim local share directory..."
    clear_nvim_local_share

    echo "✅ Neovim $version has been installed successfully."
}

# Main logic
echo "Checking for Neovim updates..."
installed_version=$(get_installed_version)

latest_version=$(get_latest_version) || exit 1
download_url="$LATEST_DOWNLOAD_URL"

echo "Installed version: $installed_version"
echo "Latest version: $latest_version"

if [[ "$installed_version" != "$latest_version" ]]; then
    echo "A new version of Neovim is available. Updating..."
    install_latest_version "$latest_version" "$download_url"
else
    echo "You already have the latest version of Neovim installed."
fi
