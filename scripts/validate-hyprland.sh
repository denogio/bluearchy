#!/usr/bin/env bash
# Script to validate Hyprland configurations in the repository
# Requires: hyprland, bubblewrap (bwrap)

set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
VALID_COUNT=0
ERROR_COUNT=0

echo "🔍 Validating Hyprland configurations..."

# Function to run Hyprland verify-config in a sandbox
validate_config() {
    local config_path="$1"
    local config_name="$2"
    
    echo -n "  Checking $config_name... "
    
    # Create a temporary home directory for the sandbox
    local tmp_home
    tmp_home=$(mktemp -d)
    
    # Setup some basic structure for the mock home
    mkdir -p "$tmp_home/.config/hypr"
    mkdir -p "$tmp_home/.config/tairon/current"
    
    # Mock the theme link if it's the skel config
    if [[ "$config_name" == *"etc/skel/.config/hypr/hyprland.conf"* ]]; then
        # Default to one of the themes for validation purposes
        ln -s "$REPO_ROOT/files/system/usr/share/tairon/themes/catppuccin" "$tmp_home/.config/tairon/current/theme"
    fi

    # Run Hyprland in a sandbox
    # We mount the repo's system files over the real ones
    if bwrap \
        --ro-bind /usr /usr \
        --ro-bind /lib /lib \
        --ro-bind /lib64 /lib64 \
        --ro-bind /bin /bin \
        --ro-bind /etc /etc \
        --dev /dev \
        --proc /proc \
        --tmpfs /tmp \
        --bind "$tmp_home" "$HOME" \
        --ro-bind "$REPO_ROOT" "$REPO_ROOT" \
        --ro-bind "$REPO_ROOT/files/system/hyprland/usr/share/hyprland" /usr/share/hyprland \
        --setenv HOME "$HOME" \
        --setenv XDG_RUNTIME_DIR "/tmp" \
        Hyprland --verify-config -c "$config_path" > /dev/null 2>&1; then
        echo "✅ PASSED"
        VALID_COUNT=$((VALID_COUNT + 1))
    else
        echo "❌ FAILED"
        # Run again without redirection to show errors
        bwrap \
            --ro-bind /usr /usr \
            --ro-bind /lib /lib \
            --ro-bind /lib64 /lib64 \
            --ro-bind /bin /bin \
            --ro-bind /etc /etc \
            --dev /dev \
            --proc /proc \
            --tmpfs /tmp \
            --bind "$tmp_home" "$HOME" \
            --ro-bind "$REPO_ROOT" "$REPO_ROOT" \
            --ro-bind "$REPO_ROOT/files/system/hyprland/usr/share/hyprland" /usr/share/hyprland \
            --setenv HOME "$HOME" \
            --setenv XDG_RUNTIME_DIR "/tmp" \
            Hyprland --verify-config -c "$config_path" || true
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
    
    rm -rf "$tmp_home"
}

# Find all hyprland.conf files in files/system
# We exclude the one in usr/share/hyprland because it's sourced by others and might depend on them
# being in the right place, which we handle via the mount.
# Actually, let's just check the main entry points.

ENTRY_POINTS=(
    "files/system/hyprland/etc/skel/.config/hypr/hyprland.conf"
    "files/system/hyprland/usr/share/hyprland/hyprland.conf"
)

# Also check all themes
while IFS= read -r theme_config; do
    ENTRY_POINTS+=("$theme_config")
done < <(find files/system/usr/share/tairon/themes -name "hyprland.conf")

for config in "${ENTRY_POINTS[@]}"; do
    if [ -f "$REPO_ROOT/$config" ]; then
        validate_config "$REPO_ROOT/$config" "$config"
    fi
done

echo ""
echo "Summary: $VALID_COUNT passed, $ERROR_COUNT failed"

if [ "$ERROR_COUNT" -gt 0 ]; then
    exit 1
fi
