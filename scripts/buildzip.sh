#!/bin/bash
# scripts/buildzip.sh

set -e  # Exit immediately if any command exits with a non-zero status

# Usage:
#   ./scripts/buildzip.sh <plugin_type> <plugin_name> <plugin_version> <moodle_channel>
# Example:
#   ./scripts/buildzip.sh mod glaaster 1.2.3 4.1

PLUGIN_TYPE=${1:-mod}       # Default to 'mod' if not provided
PLUGIN_NAME=${2:-glaaster}  # Default to 'glaaster' if not provided
PLUGIN_VERSION=${3:-dev}    # Default to 'dev' if not provided
MOODLE_CHANNEL=${4}         # Moodle branch channel, e.g. "4.1" or empty for main

# Normalize plugin type to lowercase
PLUGIN_TYPE=$(echo "$PLUGIN_TYPE" | tr '[:upper:]' '[:lower:]')

# Determine suffix for Moodle channel (skip suffix on main)
if [[ -z "$MOODLE_CHANNEL" || "$MOODLE_CHANNEL" == "main" || "$MOODLE_CHANNEL" == "undefined" ]]; then
  CHANNEL_SUFFIX=""
else
  CHANNEL_SUFFIX="_moodle${MOODLE_CHANNEL}"
fi

# Construct zip file name
ZIP_NAME="${PLUGIN_TYPE}_${PLUGIN_NAME}_v${PLUGIN_VERSION}${CHANNEL_SUFFIX}.zip"

# Navigate to project root
cd "$(dirname "$0")/.."

# Remove any existing zip with the same name
rm -f "$ZIP_NAME"

# Create zip from plugin folder
if [[ -d "${PLUGIN_TYPE}/${PLUGIN_NAME}" ]]; then
  # Move into plugins directory and zip it
  (
    cd "${PLUGIN_TYPE}" || exit 1
    zip -r "../$ZIP_NAME" "${PLUGIN_NAME}"
  )
else
  echo "❌ Error: '${PLUGIN_TYPE}/${PLUGIN_NAME}' folder not found."
  exit 1
fi

echo "✅ Package created: $ZIP_NAME"
