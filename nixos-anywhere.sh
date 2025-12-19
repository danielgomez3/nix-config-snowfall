#! /run/current-system/sw/bin/bash
set -euo pipefail

hostname="$1"
ipaddress="$2"

temp="$(mktemp -d)"
trap 'rm -rf "$temp"' EXIT

###############################################################################
# 1. Generate initrd SSH HOST key (one per host, stored locally)
###############################################################################

INITRD_HOSTKEY="$HOME/.ssh/initrd-$hostname"

if [ ! -f "$INITRD_HOSTKEY" ]; then
  echo "Generating initrd SSH host key for $hostname..."
  ssh-keygen -t ed25519 -f "$INITRD_HOSTKEY" -N "" -C "initrd-hostkey-$hostname"
fi

###############################################################################
# 2. Install it where initrd expects it: /etc/ssh/initrd
###############################################################################

install -d -m 755 "$temp/etc/ssh"

install -m 600 "$INITRD_HOSTKEY" \
  "$temp/etc/ssh/initrd"

###############################################################################
# 3. Copy SOPS age keys (unchanged)
###############################################################################

install -d -m 700 "$temp/root/.config/sops/age"
install -m 600 ~/.config/sops/age/keys.txt \
  "$temp/root/.config/sops/age/keys.txt"

###############################################################################
# 4. Deploy using nixos-anywhere
###############################################################################

nix run github:numtide/nixos-anywhere -- \
  --extra-files "$temp" \
  --flake ".#$hostname" \
  "root@$ipaddress"
