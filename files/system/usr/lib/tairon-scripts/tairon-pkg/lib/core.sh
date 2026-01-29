#!/usr/bin/env bash
# Tairon Package Manager Core Loader
# Dynamically loads and registers available backends

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"
BACKENDS_DIR="$LIB_DIR/backends"
CONFIG_DIR="/usr/share/tairon/pkg-config"

# Source UI helpers
source "$LIB_DIR/ui.sh"

# Available backends
AVAILABLE_BACKENDS=("brew" "flatpak" "dnf")
INSTALLED_BACKENDS=()

# Backend registration functions (implemented by each backend)
_register_backend_brew() { :; }
_register_backend_flatpak() { :; }
_register_backend_dnf() { :; }

# Check and register backends
check_and_register_backends() {
  INSTALLED_BACKENDS=()

  # Check brew
  if command -v brew &>/dev/null; then
    AVAILABLE_BACKENDS+=("brew")
    INSTALLED_BACKENDS+=("brew")
    if type _register_backend_brew 2>/dev/null; then
      _register_backend_brew
    else
      echo "Warning: brew backend exists but registration function not found" >&2
    fi
  fi

  # Check flatpak
  if command -v flatpak &>/dev/null; then
    AVAILABLE_BACKENDS+=("flatpak")
    INSTALLED_BACKENDS+=("flatpak")
    if type _register_backend_flatpak 2>/dev/null; then
      _register_backend_flatpak
    else
      echo "Warning: flatpak backend exists but registration function not found" >&2
    fi
  fi

  # Check dnf (future, just mark as available)
  AVAILABLE_BACKENDS+=("dnf")
  if type _register_backend_dnf 2>/dev/null; then
    _register_backend_dnf
  else
    echo "Note: dnf backend available but not yet implemented" >&2
  fi
}

# Get installed backends
get_installed_backends() {
  echo "${INSTALLED_BACKENDS[@]}"
}

# Get available backends
get_available_backends() {
  echo "${AVAILABLE_BACKENDS[@]}"
}

# Get specific backend info
get_backend_info() {
  local backend="$1"
  case "$backend" in
    brew)
      echo "Package manager for CLI and userland tools"
      echo "Commands: install, uninstall, update, search, list, info"
      ;;
    flatpak)
      echo "Package manager for desktop applications"
      echo "Commands: list, install, uninstall, info, search"
      ;;
    dnf)
      echo "System package manager for Fedora Atomic (layering)"
      echo "Status: Coming soon"
      ;;
    *)
      echo "Unknown backend: $backend" >&2
      return 1
      ;;
  esac
}

# Validate backend exists
backend_exists() {
  local backend="$1"
  [[ " ${INSTALLED_BACKENDS[@]} " =~ " ${backend} " ]]
}

# Auto-detect backend based on action
detect_backend_for_action() {
  local action="$1"

  case "$action" in
    install|uninstall|search|update)
      # For flatpak or brew
      if command -v brew &>/dev/null; then
        echo "brew"
      elif command -v flatpak &>/dev/null; then
        echo "flatpak"
      else
        return 1
      fi
      ;;
    list)
      # List from the appropriate backend
      if command -v brew &>/dev/null; then
        echo "brew"
      elif command -v flatpak &>/dev/null; then
        echo "flatpak"
      else
        return 1
      fi
      ;;
    info)
      # Show info from the appropriate backend
      if command -v brew &>/dev/null; then
        echo "brew"
      elif command -v flatpak &>/dev/null; then
        echo "flatpak"
      else
        return 1
      fi
      ;;
    *)
      return 1
      ;;
  esac
}

# Export functions for use by tairon-pkg
export -f check_and_register_backends
export -f get_installed_backends
export -f get_available_backends
export -f get_backend_info
export -f backend_exists
export -f detect_backend_for_action
