#!/usr/bin/env bash
# Script to build Tairon ISO locally using blue-build
# Requires: blue-build, sudo access

set -euo pipefail

RECIPE_FILE="recipes/recipe.yml"
ISO_NAME="tairon.iso"

echo "🚀 Starting Tairon ISO Build Process..."

# Use bluebuild to generate the ISO from the local recipe
# This automatically handles building the image and converting it
echo "💿 Generating ISO from recipe: ${RECIPE_FILE}..."
if sudo bluebuild generate-iso --iso-name "${ISO_NAME}" recipe "${RECIPE_FILE}"; then
    echo "✅ ISO generated successfully!"
    echo "📂 Location: $(pwd)/${ISO_NAME}"
    echo ""
    echo "To test this ISO in a VM:"
    echo "1. Create a new VM (GNOME Boxes or Virt-Manager)"
    echo "2. Select the ISO file: $(pwd)/${ISO_NAME}"
    echo "3. Boot and test!"
else
    echo "❌ ISO generation failed!"
    exit 1
fi
