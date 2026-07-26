#!/usr/bin/env bash
# Bump the Homebrew formula to a new version.
# Usage: update-homebrew.sh <version> <arm64-sha256>
#
# Example (called from release.yml after artifacts are built):
#   ./scripts/update-homebrew.sh 0.2.0 abc123...
set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <version> <arm64-sha256>" >&2
    exit 1
fi

VERSION="$1"
ARM64_SHA="$2"

FORMULA="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/homebrew/macgrind.rb"

if [[ ! -f "$FORMULA" ]]; then
    echo "ERROR: formula not found at $FORMULA" >&2
    exit 1
fi

# Bump version line
sed -i.bak "s/version \"[^\"]*\"/version \"${VERSION}\"/" "$FORMULA"

# Bump the release URL (arm64 only — see fix/arm64-only-release).
sed -i.bak \
    "s|releases/download/v[^/]*/macgrind-[^-]*-arm64|releases/download/v${VERSION}/macgrind-${VERSION}-arm64|g" \
    "$FORMULA"

# Bump the sha256 line. The formula has exactly one.
sed -i.bak "s/sha256 \"[^\"]*\"/sha256 \"${ARM64_SHA}\"/" "$FORMULA"

rm -f "${FORMULA}.bak"
echo "Formula updated to v${VERSION}: sha256=${ARM64_SHA:0:12}..."
