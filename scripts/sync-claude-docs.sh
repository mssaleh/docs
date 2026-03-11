#!/usr/bin/env bash
set -euo pipefail

# Determine the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KNOWLEDGE_DIR="$(cd "${SCRIPT_DIR}/../claude" && pwd)"

# Allow overriding LLMS_URL via environment variable, with a safe default
LLMS_URL="${LLMS_URL:-https://platform.claude.com/llms.txt}"
LLMS_FILE="${KNOWLEDGE_DIR}/llms.txt"

echo "Downloading ${LLMS_URL} to ${LLMS_FILE}..."
# -sS hides progress bar but shows errors. -L follows redirects.
curl -sS -L -o "${LLMS_FILE}" "${LLMS_URL}"

echo "Parsing URLs from ${LLMS_FILE}..."
# Extract URLs ending in .md (compatible with both GNU and BSD grep for Linux/macOS/Windows Git Bash)
URLS=$(grep -oE 'https://[^)]+\.md' "${LLMS_FILE}")

if [ -z "$URLS" ]; then
    echo "No URLs found in ${LLMS_FILE}."
    exit 1
fi

echo "Downloading markdown files..."
if [ "${SKIP_MD_DOWNLOADS:-false}" != "true" ]; then
    for URL in $URLS; do
        # Extract the relative path from the URL to preserve directory structure
        REL_PATH="${URL#https://platform.claude.com/docs/en/}"
        
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

echo "All documentation files have been synced to ${KNOWLEDGE_DIR}."
