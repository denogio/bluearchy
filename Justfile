# Build ISO for testing
iso:
    ./scripts/build-iso.sh

# Test the generated ISO in a QEMU VM
test-iso:
    ./scripts/test-iso.sh

# Validate Hyprland configurations locally
validate-config:
    ./scripts/validate-hyprland.sh

alias upgrade := update

# Update system and Homebrew packages
update VERB_LEVEL="full":
    #!/usr/bin/bash
    if [ "{{ VERB_LEVEL }}" = "help" ]; then
        ujust update help
        exit 0
    fi
    ujust update {{ VERB_LEVEL }}
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        echo "Updating Homebrew..."
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        brew update
        brew upgrade
    fi
