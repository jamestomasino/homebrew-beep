#!/usr/bin/env bash
set -euo pipefail

TAG="${1:-}"
REPO="${2:-jamestomasino/beep}"
FORMULA="${3:-/home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/jamestomasino/homebrew-beep/Formula/beep.rb}"

if [[ -z "${TAG}" ]]
then
  echo "Usage: ${0} <tag|version> [repo] [formula_path]" >&2
  echo "Example: ${0} v0.1.0" >&2
  exit 1
fi

if [[ "${TAG}" != v* ]]
then
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

if [[ -z "${DARWIN_ARM_SHA}" || -z "${DARWIN_X86_SHA}" || -z "${LINUX_X86_SHA}" ]]
then
  echo "Failed to read checksum values from downloaded assets" >&2
  exit 1
fi

echo "Updating formula: ${FORMULA}"
perl -i -pe "s/^  version \"[^\"]+\"/  version \"${VERSION}\"/" "${FORMULA}"
perl -i -pe "s#^  url \"https://github\\.com/jamestomasino/beep/releases/download/v[^/]+/beep-v[^-]+-linux-x86_64\\.tar\\.gz\"#  url \"https://github.com/jamestomasino/beep/releases/download/v${VERSION}/beep-v${VERSION}-linux-x86_64.tar.gz\"#" "${FORMULA}"
perl -0777 -i -pe "s{(beep-v\\#\\{version\\}-darwin-arm64\\.tar\\.gz\"\\n\\s+sha256 \")[^\"]+(\"\\n)}{\${1}${DARWIN_ARM_SHA}\${2}}g" "${FORMULA}"
perl -0777 -i -pe "s{(beep-v\\#\\{version\\}-darwin-x86_64\\.tar\\.gz\"\\n\\s+sha256 \")[^\"]+(\"\\n)}{\${1}${DARWIN_X86_SHA}\${2}}g" "${FORMULA}"
perl -0777 -i -pe "s{(beep-v\\#\\{version\\}-linux-x86_64\\.tar\\.gz\"\\n\\s+sha256 \")[^\"]+(\"\\n)}{\${1}${LINUX_X86_SHA}\${2}}g" "${FORMULA}"

echo "Updated to ${TAG}"
echo "  darwin arm64 sha256: ${DARWIN_ARM_SHA}"
echo "  darwin x86_64 sha256: ${DARWIN_X86_SHA}"
echo "  linux x86_64 sha256: ${LINUX_X86_SHA}"
