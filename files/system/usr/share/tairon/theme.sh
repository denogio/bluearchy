#!/usr/bin/env bash
# Tairon Gum Theme
# Based on Catppuccin theme colors
# Designed to be used with gum for beautiful CLI experiences

# Tairon branding colors (matching tairon-logo and aesthetic)
# Primary: Deep purple (#7aa2f7)
# Secondary: Blue-green (#42a5f5)
# Accent: Red-orange (#f7768e)
# Neutral: Gray (#9ca0af)
# Background: Dark (#1e1e2e)

# Color definitions
COLOR_PRIMARY="#7aa2f7"
COLOR_SECONDARY="#42a5f5"
COLOR_ACCENT="#f7768e"
COLOR_NEUTRAL="#9ca0af"
COLOR_BG="#1e1e2e"

# Print Tairon logo with gum colors
print_logo() {
  gum style \
    --foreground "$COLOR_PRIMARY" \
    --border double \
    --align center \
    --padding "1 2" \
    "$(cat /usr/share/tairon/logo.txt)"
}

# Get theme color for gum
get_accent() {
  echo "$COLOR_ACCENT"
}

# Get background color for gum
get_background() {
  echo "$COLOR_BG"
}

# Get border color for gum
get_border() {
  echo "$COLOR_PRIMARY"
}

# Highlight color for success/error/info
highlight_success() {
  echo "$COLOR_SECONDARY"
}

highlight_error() {
  echo "#f7768e"
}

highlight_info() {
  echo "#42a5f5"
}
