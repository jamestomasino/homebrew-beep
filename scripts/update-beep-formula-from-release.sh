#!/usr/bin/env bash
set -euo pipefail

TAG="${1:-}"
REPO="${2:-jamestomasino/beep}"
FORMULA="${3:-/home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/jamestomasino/homebrew-beep/Formula/beep.rb}"

if [[ -z "$TAG" ]]; then
  echo "Usage: $0 <tag|version> [repo] [formula_path]" >&2
  echo "Example: $0 v0.1.0" >&2
  exit 1
fi

if [[ "$TAG" != v* ]]; then
  TAG="v$TAG"
fi

VERSION="${TAG#v}"
ARM_FILE="beep-${TAG}-darwin-arm64.sha256"
X86_FILE="beep-${TAG}-darwin-x86_64.sha256"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading release checksum assets for ${REPO} ${TAG}..."
gh release download "$TAG" -R "$REPO" -p "$ARM_FILE" -D "$TMP_DIR"
gh release download "$TAG" -R "$REPO" -p "$X86_FILE" -D "$TMP_DIR"

ARM_SHA="$(awk '{print $1}' "$TMP_DIR/$ARM_FILE")"
X86_SHA="$(awk '{print $1}' "$TMP_DIR/$X86_FILE")"

if [[ -z "$ARM_SHA" || -z "$X86_SHA" ]]; then
  echo "Failed to read checksum values from downloaded assets" >&2
  exit 1
fi

echo "Updating formula: $FORMULA"
perl -i -pe '
  BEGIN { $sha_idx = 0 }
  if (/^  version "/) {
    s/version "[^"]+"/version "'"$VERSION"'"/;
  }
  if (/^      sha256 "/) {
    $sha_idx++;
    if ($sha_idx == 1) {
      s/sha256 "[^"]+"/sha256 "'"$ARM_SHA"'"/;
    } elsif ($sha_idx == 2) {
      s/sha256 "[^"]+"/sha256 "'"$X86_SHA"'"/;
    }
  }
' "$FORMULA"

echo "Updated to ${TAG}"
echo "  arm64 sha256: $ARM_SHA"
echo "  x86_64 sha256: $X86_SHA"
