#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused gnugrep nix

set -euo pipefail

release_json="$(curl -fsSL https://api.github.com/repos/imputnet/helium-linux/releases/latest)"
latest_version="$(jq -r '.tag_name' <<<"$release_json")"

if [[ -z "$latest_version" || "$latest_version" == "null" ]]; then
  echo "error: could not fetch latest helium version from GitHub" >&2
  exit 1
fi

url="https://github.com/imputnet/helium-linux/releases/download/${latest_version}/helium-${latest_version}-x86_64.AppImage"
hash="$(nix-prefetch-url --type sha256 "$url")"
sri_hash="$(nix hash convert --hash-algo sha256 --to sri "$hash")"
file="pkgs/helium/package.nix"
old_version="${UPDATE_NIX_OLD_VERSION:-$(grep -oP '(?<=version = ")[^"]+' "$file" | head -n1)}"
old_hash="$(grep -oP '(?<=hash = ")[^"]+' "$file" | head -n1)"

if [[ "$old_version" == "$latest_version" && "$old_hash" == "$sri_hash" ]]; then
  echo "helium is already up to date: ${latest_version}"
  exit 0
fi

sed -i \
  -e "s/version = \"${old_version}\";/version = \"${latest_version}\";/" \
  -e "s|hash = \"${old_hash}\";|hash = \"${sri_hash}\";|" \
  "$file"
