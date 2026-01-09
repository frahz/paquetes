#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl yq gnused common-updater-scripts

set -euo pipefail

HAYASE_LATEST_VER="$(curl "https://api.hayase.watch/files/latest-linux.yml" | yq -r .version | sed 's/^v//')"

if [[ "$HAYASE_LATEST_VER" == "null" ]]; then
    echo "error: could not fetch hayase latest version from API" >&2
    exit 1
fi

echo "latest hayase version: ${HAYASE_LATEST_VER}"

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
