#!/usr/bin/env bash
set -euo pipefail

# Determine the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KNOWLEDGE_DIR="$(cd "${SCRIPT_DIR}/../code" && pwd)"

# Allow overriding LLMS_URL via environment variable, with a safe default
LLMS_URL="${LLMS_URL:-https://code.claude.com/docs/llms.txt}"
LLMS_FILE="${KNOWLEDGE_DIR}/llms.txt"

echo "Downloading ${LLMS_URL} to ${LLMS_FILE}..."
# -sS hides progress bar but shows errors. -L follows redirects.
curl -sS -L -o "${LLMS_FILE}" "${LLMS_URL}"

echo "Parsing URLs from ${LLMS_FILE}..."
# Extract URLs ending in .md (compatible with both GNU and BSD grep for Linux/macOS/Windows Git Bash)
# We filter out the CHANGELOG.md from llms.txt as we download the real CHANGELOG.md from GitHub
URLS=$(grep -oE 'https://[^)]+\.md' "${LLMS_FILE}" | grep -v -i "CHANGELOG.md")

if [ -z "$URLS" ]; then
    echo "No URLs found in ${LLMS_FILE}."
    exit 1
fi

echo "Downloading markdown files..."
if [ "${SKIP_MD_DOWNLOADS:-false}" != "true" ]; then
    for URL in $URLS; do
        # Extract the relative path from the URL to preserve directory structure
        # e.g., https://code.claude.com/docs/en/guides/overview.md -> guides/overview.md
        REL_PATH="${URL#https://code.claude.com/docs/}"
        
        TARGET_FILE="${KNOWLEDGE_DIR}/${REL_PATH}"
        TARGET_DIR="$(dirname "${TARGET_FILE}")"
        
        # Create subdirectories as needed
        mkdir -p "${TARGET_DIR}"
        
        echo "  -> Downloading ${REL_PATH}..."
        curl -sS -L -o "${TARGET_FILE}" "${URL}"
        
        # Verify the downloaded file is not an HTML page (e.g., due to redirects to GitHub UI)
        if head -n 5 "${TARGET_FILE}" | grep -qi "<html"; then
            echo "  -> Warning: ${REL_PATH} appears to be an HTML page. Removing."
            rm -f "${TARGET_FILE}"
        fi
        
        # Delay to avoid rate-limiting or tripping anti-bot protections
        sleep 1
    done
else
    echo "Skipping markdown downloads for testing..."
fi

# Download CHANGELOG.md
CHANGELOG_URL="https://raw.githubusercontent.com/anthropics/claude-code/refs/heads/main/CHANGELOG.md"
CHANGELOG_FILE="${KNOWLEDGE_DIR}/CHANGELOG.md"
echo "Downloading CHANGELOG.md..."
curl -sS -L -o "${CHANGELOG_FILE}" "${CHANGELOG_URL}"

# Verify the downloaded CHANGELOG.md is valid markdown and not an HTML page
if [ ! -s "${CHANGELOG_FILE}" ]; then
    echo "Error: Downloaded CHANGELOG.md is empty."
    exit 1
fi

if head -n 5 "${CHANGELOG_FILE}" | grep -qi "<html"; then
    echo "Error: Downloaded CHANGELOG.md appears to be an HTML page."
    exit 1
fi

# Extract the latest version number from CHANGELOG.md
VERSION_FILE="${KNOWLEDGE_DIR}/claude-code-version.txt"
echo "Extracting latest Claude Code version..."
# Look for the first line starting with "## " followed by a version number (e.g., "## 0.2.0" or "## [0.2.0]")
LATEST_VERSION=$(grep -oE '^## \[?[0-9]+\.[0-9]+\.[0-9]+\]?' "${CHANGELOG_FILE}" | head -n 1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || true)

if [ -n "$LATEST_VERSION" ]; then
    echo "$LATEST_VERSION" > "${VERSION_FILE}"
    echo "Latest version is $LATEST_VERSION"
else
    echo "Warning: Could not extract version from CHANGELOG.md"
fi

echo "All documentation files have been synced to ${KNOWLEDGE_DIR}."
