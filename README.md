
                                      
                                             
##                                     ▄▄▄ ▄▄ ▄▄ 
##     ██        ▀▀                     █  █ ▀ █ 
##    ▀██▀▀ ▀▀█▄ ██  ████▄ ▄███▄ ████▄             
##     ██  ▄█▀██ ██  ██ ▀▀ ██ ██ ██ ██             
##     ██  ▀█▄██ ██▄ ██    ▀███▀ ██ ██             
                                             
                                             

[![bluebuild build badge](https://github.com/denogio/tairon/actions/workflows/build.yml/badge.svg)](https://github.com/denogio/tairon/actions/workflows/build.yml)

**Tairon** is a developer-focused, immutable Fedora Atomic distro built with Universal Blue.
It combines Hyprland, Vicinae launcher, and powerful developer tools to create a minimal,
dark, and unapologetically productive desktop experience.

Minimal. Dark. Developer-First. Atomic.

## Features

- **Hyprland** - Fast, dynamic tiling Wayland compositor
- **Vicinae** - Keyboard-driven launcher with plugins and dmenu support
- **Waybar** - Customizable status bar with developer-friendly modules
- **Ghostty** - Modern terminal emulator
- **Developer Tools** - Homebrew-based installation of ripgrep, fd, bat, eza, starship, lazygit, zoxide
- **Auto-updates** - Seamless rpm-ostree updates
- **Immutable Base** - Fedora Atomic with Universal Blue

## Installation

> [!WARNING]
> This is experimental territory. Proceed with caution.

Rebase an existing Fedora Atomic system to Tairon:

1. Rebase to the unsigned image first:

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/denogio/tairon:latest
```

2. Reboot:

```bash
systemctl reboot
```

3. Rebase to the signed image:

```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/denogio/tairon:latest
```

4. Reboot again:

```bash
systemctl reboot
```

> The `latest` tag always points to the newest build.

## First Setup

On first login, the Tairon setup wizard will guide you through:
- Installing developer tools (via Homebrew)
- Configuring Git
- Generating SSH keys
- Setting up wallpapers

You can also run the setup wizard manually:

```bash
tairon-setup
```

## Developer Tools

Tairon comes with a justfile for managing developer tools:

```bash
# Show all available commands
just

# Install all developer tools (ripgrep, fd, bat, eza, starship, lazygit, zoxide)
just dev-tools

# Configure developer tools (aliases, prompts)
just dev-setup

# Show installed tool versions
just dev-info

# Update all tools
just dev-update

# Clean up old versions
just dev-clean
```

## Vicinae Launcher

Tairon uses Vicinae as the primary launcher with extensive customizations:

### Key Features:
- **Application launcher** - SUPER+R
- **System controls menu** - SUPER+SHIFT+R (dmenu mode)
- **Window management** - Built-in support
- **Clipboard management** - Built-in support
- **Plugin system** - Extensible with community plugins

### System Controls:
- Power management (reboot, suspend, lock)
- Display settings (brightness, night mode)
- Network controls (WiFi, Bluetooth)
- System info (CPU, memory, temperature)
- System configuration

## Keybindings

### Hyprland:
- **SUPER+Q** - Open terminal (Ghostty)
- **SUPER+E** - File manager (Thunar)
- **SUPER+R** - Vicinae launcher
- **SUPER+SHIFT+R** - Vicinae system controls (dmenu)
- **SUPER+L** - Lock screen
- **SUPER+Print** - Screenshot (region)
- **SUPER+SHIFT+Print** - Screenshot (full screen)
- **Arrow keys** - Navigate windows
- **0-9** - Switch workspaces

### Vicinae:
- **Ctrl+P** - Search filter
- **Ctrl+,** - Open settings
- **Ctrl+B** - Toggle action panel
- **Ctrl+R** - Refresh

## Wallpaper Management

Set wallpapers using Vicinae:

1. Press SUPER+R to open Vicinae
2. Select "Wallpaper Picker"
3. Browse and select a wallpaper

Wallpapers should be placed in: `~/Pictures/Wallpapers/`

## Backups & Restore

Backup your Tairon configuration:

```bash
tairon-backup
```

Restore from backup:

```bash
tairon-restore <backup-file>
```

Backups are stored in: `~/.config/tairon/backups/`

## Updates

Update Tairon:

```bash
tairon-update
```

Or manually:

```bash
rpm-ostree upgrade
systemctl reboot
```

Clean up old deployments:

```bash
tairon-clean
```

## ISO

Generate an offline ISO from a Fedora Atomic system following
[Universal Blue instructions](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso).

> ⚠️ GitHub cannot host these ISOs due to size. Public projects require external hosting.

## Verification

All images are signed with [Sigstore](https://www.sigstore.dev/) via [cosign](https://github.com/sigstore/cosign).

Verify your build with:

```bash
cosign verify --key cosign.pub ghcr.io/denogio/tairon
```

## Configuration Files

Key configuration locations:
- **Hyprland:** `~/.config/hypr/hyprland.conf`
- **Waybar:** `~/.config/waybar/`
- **Vicinae:** `~/.config/vicinae/`
- **Ghostty:** `~/.config/ghostty/config`
- **Neovim:** `~/.config/nvim/init.lua`
- **Shell:** `~/.bashrc`

## Troubleshooting

### Vicinae not working
```bash
systemctl --user restart vicinae
```

### Waybar not showing
```bash
systemctl --user restart waybar
```

### Reset Hyprland config
```bash
cp /usr/share/hyprland/hyprland.conf ~/.config/hypr/hyprland.conf
```

## Building Locally

Build Tairon locally using blue-build:

```bash
# Install blue-build
pip install blue-build

# Build image
blue-build build recipes/recipe.yml
```

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Development

This project uses ShellCheck to ensure bash script quality and follows strict coding standards.

### Code Quality

**ShellCheck Integration:**
- All shell scripts are validated with ShellCheck
- Pre-commit hooks ensure quality before commits
- CI/CD pipeline validates code on pull requests
- Zero shellcheck warnings/errors are allowed

**Running ShellCheck Locally:**
```bash
# Install shellcheck in distrobox container
distrobox create -n shellcheck-dev -i registry.fedoraproject.org/fedora:41 --yes
distrobox enter shellcheck-dev -- sudo dnf install -y ShellCheck

# Run shellcheck on all scripts
bash scripts/lint-shell.sh
```

**Project Structure:**
- `files/system/usr/share/tairon/` - Tairon branding and themes
- `files/system/usr/lib/tairon/pkg/` - Package manager system
- `files/scripts/` - System setup and maintenance scripts
- `scripts/` - Development utilities and quality checks

### Contributing

When contributing to Tairon:
1. All shell scripts must pass ShellCheck validation
2. Follow existing code patterns and conventions
3. Test changes in a distrobox environment
4. Ensure pre-commit hooks pass before committing

**Setup Development Environment:**
```bash
# Install pre-commit hooks
pipx install pre-commit
pre-commit install

# Create shellcheck container
distrobox create -n shellcheck-dev -i registry.fedoraproject.org/fedora:41 --yes
distrobox enter shellcheck-dev -- sudo dnf install -y ShellCheck

# Test your changes
pre-commit run shellcheck --all-files
```

## License

Licensed under same license as Universal Blue (Apache License 2.0).

See [LICENSE](LICENSE) for details.

## Credits

Built with ❤️ using:
- [Universal Blue](https://universal-blue.org/)
- [Fedora Atomic](https://fedoraproject.org/atomic-desktops/)
- [Hyprland](https://hyprland.org/)
- [Vicinae](https://vicinae.com/)
- [Blue Build](https://blue-build.org/)

Made with 🖤 by [denogio](https://github.com/denogio)
