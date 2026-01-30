alias dev := dev-setup

# Install all developer tools via Homebrew
# Note: Homebrew is handled by blue-build via 'type: brew' module
dev-tools:
    #!/usr/bin/env bash
    set -e

    # Check if brew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. It should be installed by blue-build."
        just install-brew
        exit 1
    fi

    echo "Installing developer tools..."

    # Ensure ublue-os tap is available
    brew tap ublue-os/tap 2>/dev/null || true

    # Core tools
    brew install ripgrep fd-find bat eza starship lazygit zoxide

    # IDE & Tools from ublue-os tap
    brew install --cask ublue-os/tap/visual-studio-code-linux
    brew install --cask ublue-os/tap/antigravity-linux

    echo "Developer tools installed!"
    echo "Run 'just dev-setup' to configure them."

# Set up developer environment (configure tools)
dev-setup:
    #!/usr/bin/env bash
    set -e

    # Configure zoxide
    if ! grep -q 'eval "$(zoxide init --cmd cd bash)"' ~/.bashrc 2>/dev/null; then
        echo '' >> ~/.bashrc
        echo '# zoxide' >> ~/.bashrc
        echo 'eval "$(zoxide init --cmd cd bash)"' >> ~/.bashrc
    fi

    # Configure starship
    if ! grep -q 'eval "$(starship init bash)"' ~/.bashrc 2>/dev/null; then
        echo '' >> ~/.bashrc
        echo '# starship prompt' >> ~/.bashrc
        echo 'eval "$(starship init bash)"' >> ~/.bashrc
    fi

    # Create starship config
    mkdir -p ~/.config
    cat > ~/.config/starship.toml << 'EOF'
    # Starship config for Tairon
    add_newline = false
    format = '$directory$git_branch$git_status$character'

    [character]
    success_symbol = '[➜](bold green)'
    error_symbol = '[➜](bold red)'

    [directory]
    style = 'bold blue'

    [git_branch]
    style = 'bold purple'

    [git_status]
    style = 'bold yellow'
    EOF

    # Configure bat
    mkdir -p ~/.config/bat
    cat > ~/.config/bat/config << 'EOF'
    # Bat config
    --theme=base16
    --style=numbers,changes
    --wrap=never
    EOF

    # Configure ripgrep
    mkdir -p ~/.config
    cat > ~/.config/ripgreprc << 'EOF'
    # Ripgrep config
    --smart-case
    --follow
    --hidden
    --glob=!.git/*
    EOF

    echo "Developer environment configured!"
    echo "Open a new terminal for changes to take effect."

# Install Homebrew (alias)
# Note: Homebrew is handled by blue-build via 'type: brew' module
install-brew:
    #!/usr/bin/env bash
    echo "Homebrew is installed by blue-build via the 'type: brew' module."
    echo "No manual installation required."
    echo ""
    echo "If Homebrew is not found, please ensure your Tairon image"
    echo "was built with the brew module enabled in recipes/extra-packages.yml"
    echo ""
    echo "Current status:"
    if command -v brew &> /dev/null; then
        echo "✓ Homebrew is available at: $(brew --prefix)"
        echo "Version: $(brew --version | head -n1)"
    else
        echo "✗ Homebrew not found in PATH"
        echo ""
        echo "To rebuild Tairon with Homebrew:"
        echo "  1. Ensure 'type: brew' module is in recipes/extra-packages.yml"
        echo "  2. Run: blue-build build recipes/recipe.yml"
    fi

# Remove Homebrew
remove-brew:
    echo "Removing homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

# Show developer tool versions
dev-info:
    #!/usr/bin/env bash
    echo "Tairon Developer Tools"
    echo "======================"
    echo ""
    echo "Homebrew: $(brew --version 2>/dev/null | head -n1 || echo 'Not installed')"
    echo "ripgrep: $(rg --version 2>/dev/null | head -n1 || echo 'Not installed')"
    echo "fd: $(fd --version 2>/dev/null || echo 'Not installed')"
    echo "bat: $(bat --version 2>/dev/null || echo 'Not installed')"
    echo "eza: $(eza --version 2>/dev/null || echo 'Not installed')"
    echo "starship: $(starship --version 2>/dev/null || echo 'Not installed')"
    echo "lazygit: $(lazygit --version 2>/dev/null || echo 'Not installed')"
    echo "zoxide: $(zoxide --version 2>/dev/null || echo 'Not installed')"
    echo ""
    echo "IDEs & Tools:"
    echo "  VSCode: $(code --version 2>/dev/null || echo 'Not installed')"
    echo "  Antigravity: $(antigravity --version 2>/dev/null || echo 'Not installed')"

# Update all developer tools
dev-update:
    brew upgrade
    brew upgrade --cask

# Create developer-focused project template
dev-new project:
    #!/usr/bin/env bash
    if [ -z "{{project}}" ]; then
        echo "Usage: just dev-new <project-name>"
        exit 1
    fi
    mkdir -p "{{project}}"
    cd "{{project}}"
    # Initialize git
    git init
    # Create README
    echo "# {{project}}" > README.md
    # Create .gitignore
    echo ".git/" > .gitignore
    echo "node_modules/" >> .gitignore
    echo "target/" >> .gitignore
    echo "*.pyc" >> .gitignore
    echo "Project '{{project}}' created!"
