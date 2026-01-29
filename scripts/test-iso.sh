#!/usr/bin/env bash
# Script to test the generated Tairon ISO in a QEMU VM
# Requires: qemu-system-x86_64

set -euo pipefail

ISO_PATH="tairon.iso"
DISK_PATH="test-vm-disk.qcow2"
DISK_SIZE="20G"
MEMORY="4G"
CPUS="4"

if [ ! -f "$ISO_PATH" ]; then
    echo "❌ ISO not found at $ISO_PATH"
    echo "💡 Run 'just iso' first to generate it."
    exit 1
fi

# Create a temporary disk image if it doesn't exist
if [ ! -f "$DISK_PATH" ]; then
    echo "💽 Creating temporary 20GB disk image ($DISK_PATH)..."
    qemu-img create -f qcow2 "$DISK_PATH" "$DISK_SIZE"
fi

echo "🖥️  Starting QEMU VM..."
echo "Press Ctrl+Alt+G to release mouse/keyboard."

# Run QEMU with basic acceleration
# Note: --enable-kvm only works on Linux with KVM supported/enabled
QEMU_CMD="qemu-system-x86_64"
QEMU_OPTS=(
    "-m $MEMORY"
    "-smp $CPUS"
    "-drive file=$DISK_PATH,format=qcow2"
    "-cdrom $ISO_PATH"
    "-boot d"
    "-vga virtio"
    "-display default,show-cursor=on"
    "-usb"
    "-device usb-tablet"
    "-net nic -net user"
)

if [ -e /dev/kvm ]; then
    QEMU_OPTS+=("-enable-kvm" "-cpu host")
    echo "✅ KVM acceleration enabled."
else
    echo "⚠️  KVM not available, performance will be slow."
fi

echo "$QEMU_CMD "${QEMU_OPTS[@]}""
