#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl yq gnused common-updater-scripts

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [[ ! "$(basename "$ROOT")" == "hayase" || ! -f "$ROOT/package.nix" ]]; then
    echo "error: Not in the hayase folder" >&2
    exit 1
fi

PACKAGE_NIX="$ROOT/package.nix"

HAYASE_LATEST_VER="$(curl "https://api.hayase.watch/files/latest-linux.yml" | yq -r .version | sed 's/^v//')"
HAYASE_CURRENT_VER="$(grep -oP 'version = "\K[^"]+' "$PACKAGE_NIX")"

if [[ "$HAYASE_LATEST_VER" == "null" ]]; then
    echo "error: could not fetch hayase latest version from API" >&2
    exit 1
fi

if [[ "$HAYASE_LATEST_VER" == "$HAYASE_CURRENT_VER" ]]; then
    echo "hayase is up-to-date"
    exit 0
fi

get_hash() {
    # $1: URL
    nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "$1")"
}

URL="https://api.hayase.watch/files/linux-hayase-${HAYASE_LATEST_VER}-linux.AppImage"

if ! curl -sfI "$URL" >/dev/null; then
  echo "AppImage not found for version $HAYASE_LATEST_VER, skipping update"
  exit 0
fi

HAYASE_LINUX_HASH="$(get_hash "$URL")"

update-source-version hayase "$HAYASE_LATEST_VER" "$HAYASE_LINUX_HASH"
