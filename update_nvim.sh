#!/bin/bash

# Configuration
NVIM_BIN="/opt/nvim-linux64/bin/nvim"
NVIM_DIR="/opt/nvim-linux64"
LATEST_RELEASE_API="https://api.github.com/repos/neovim/neovim/releases/latest"
DOWNLOAD_URL_BASE="https://github.com/neovim/neovim/releases/download"
NVIM_LOCAL_SHARE="$HOME/.local/share/nvim"

# Function to get the installed version
get_installed_version() {
    if [[ -x "$NVIM_BIN" ]]; then
        "$NVIM_BIN" --version | head -n 1 | awk '{print $2}'
    else
        echo "0.0.0"
    fi
}

# Function to get the latest version
get_latest_version() {
    curl -s "$LATEST_RELEASE_API" | grep -Po '"tag_name": "\K[^"]+'
}

# Function to clear Neovim local share directory
clear_nvim_local_share() {
    if [[ -d "$NVIM_LOCAL_SHARE" ]]; then
        echo "Clearing $NVIM_LOCAL_SHARE..."
        rm -rf "$NVIM_LOCAL_SHARE"
        echo "$NVIM_LOCAL_SHARE has been cleared."
    else
        echo "$NVIM_LOCAL_SHARE does not exist, skipping."
    fi
}

# Function to download and install Neovim
install_latest_version() {
    local version="$1"
    local download_url="${DOWNLOAD_URL_BASE}/${version}/nvim-linux64.tar.gz"
    local temp_dir

    echo "Downloading Neovim $version..."
    temp_dir=$(mktemp -d)
    curl -L "$download_url" -o "$temp_dir/nvim-linux64.tar.gz"

    echo "Extracting Neovim..."
    tar -xzf "$temp_dir/nvim-linux64.tar.gz" -C "$temp_dir"

    echo "Replacing the current Neovim installation..."
    rm -rf "$NVIM_DIR"
    mv "$temp_dir/nvim-linux64" "$NVIM_DIR"

    echo "Cleaning up..."
    rm -rf "$temp_dir"

    echo "Clearing Neovim local share directory..."
    clear_nvim_local_share

    echo "Neovim $version has been installed successfully."
}

# Main script logic
echo "Checking for Neovim updates..."
installed_version=$(get_installed_version)
latest_version=$(get_latest_version)

echo "Installed version: $installed_version"
echo "Latest version: $latest_version"

if [[ "$installed_version" != "$latest_version" ]]; then
    echo "A new version of Neovim is available. Updating..."
    install_latest_version "$latest_version"
else
    echo "You already have the latest version of Neovim installed."
fi
