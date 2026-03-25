#!/usr/bin/env bash
set -euo pipefail

TAG="${1:-}"
REPO="${2:-jamestomasino/beep}"
FORMULA="${3:-/home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/jamestomasino/homebrew-beep/Formula/beep.rb}"

if [[ -z "${TAG}" ]]; then
  echo "Usage: ${0} <tag|version> [repo] [formula_path]" >&2
  echo "Example: ${0} v0.1.0" >&2
  exit 1
fi

if [[ "${TAG}" != v* ]]; then
  TAG="v${TAG}"
fi

VERSION="${TAG#v}"
DARWIN_ARM_FILE="beep-${TAG}-darwin-arm64.sha256"
DARWIN_X86_FILE="beep-${TAG}-darwin-x86_64.sha256"
LINUX_X86_FILE="beep-${TAG}-linux-x86_64.sha256"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading release checksum assets for ${REPO} ${TAG}..."
gh release download "${TAG}" -R "${REPO}" -p "${DARWIN_ARM_FILE}" -D "${TMP_DIR}"
gh release download "${TAG}" -R "${REPO}" -p "${DARWIN_X86_FILE}" -D "${TMP_DIR}"
gh release download "${TAG}" -R "${REPO}" -p "${LINUX_X86_FILE}" -D "${TMP_DIR}"

DARWIN_ARM_SHA="$(awk '{print $1}' "${TMP_DIR}/${DARWIN_ARM_FILE}")"
DARWIN_X86_SHA="$(awk '{print $1}' "${TMP_DIR}/${DARWIN_X86_FILE}")"
LINUX_X86_SHA="$(awk '{print $1}' "${TMP_DIR}/${LINUX_X86_FILE}")"

if [[ -z "${DARWIN_ARM_SHA}" || -z "${DARWIN_X86_SHA}" || -z "${LINUX_X86_SHA}" ]]; then
  echo "Failed to read checksum values from downloaded assets" >&2
  exit 1
fi

echo "Updating formula: ${FORMULA}"
perl -i -pe '
  BEGIN { $target = "" }
  if (/^  version "/) {
    s/version "[^"]+"/version "'"$VERSION"'"/;
  }
  if (/url ".*darwin-arm64\.tar\.gz"/) {
    $target = "darwin_arm64";
  } elsif (/url ".*darwin-x86_64\.tar\.gz"/) {
    $target = "darwin_x86_64";
  } elsif (/url ".*linux-x86_64\.tar\.gz"/) {
    $target = "linux_x86_64";
  }
  if (/^\s+sha256 "/ && $target ne "") {
    if ($target eq "darwin_arm64") {
      s/sha256 "[^"]+"/sha256 "'"$DARWIN_ARM_SHA"'"/;
    } elsif ($target eq "darwin_x86_64") {
      s/sha256 "[^"]+"/sha256 "'"$DARWIN_X86_SHA"'"/;
    } elsif ($target eq "linux_x86_64") {
      s/sha256 "[^"]+"/sha256 "'"$LINUX_X86_SHA"'"/;
    }
    $target = "";
  }
' "${FORMULA}"

echo "Updated to ${TAG}"
echo "  darwin arm64 sha256: ${DARWIN_ARM_SHA}"
echo "  darwin x86_64 sha256: ${DARWIN_X86_SHA}"
echo "  linux x86_64 sha256: ${LINUX_X86_SHA}"
