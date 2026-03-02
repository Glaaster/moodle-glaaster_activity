#!/usr/bin/env bash
# bump-version.sh: update mod/glaaster/version.php to Moodle version format
# Usage: bump-version.sh <semver>
# Example: bump-version.sh 4.1.2

set -e  # Exit on any error

if [ -z "$1" ]; then
  echo "❌ Usage: bump-version.sh <X.Y.Z>"
  exit 1
fi

SEMVER="$1"
echo "🚀 Updating version to: $SEMVER"

# Validate semver format
if ! echo "$SEMVER" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "❌ Invalid semver format. Expected X.Y.Z (e.g., 1.0.3)"
  exit 1
fi

# Get patch number (Z in X.Y.Z), pad to two digits
PATCH=$(echo "$SEMVER" | awk -F. '{printf "%02d", $3}')
echo "📝 Patch number: $PATCH"

# Build version YYYYMMDDXX
DATE=$(date +%Y%m%d)
VERSION_INT="${DATE}${PATCH}"
echo "📅 New version integer: $VERSION_INT"

# Target file path from repo root
FILE="mod/glaaster/version.php"

# Check if file exists
if [ ! -f "$FILE" ]; then
  echo "❌ File not found: $FILE"
  echo "📁 Current directory: $(pwd)"
  echo "📁 Directory contents:"
  ls -la
  echo ""
  echo "📁 mod/ directory contents:"
  ls -la mod/ 2>/dev/null || echo "mod/ directory not found"
  exit 1
fi

echo "✅ Found version file: $FILE"

# Display current file content for debugging
echo ""
echo "📄 Current content of $FILE:"
cat "$FILE"
echo ""

# Extract current version
CURRENT_VERSION=$(grep -E '\$plugin->version\s*=' "$FILE" | head -1)
if [ -n "$CURRENT_VERSION" ]; then
  echo "📋 Current version line: $CURRENT_VERSION"
else
  echo "⚠️  Could not find current version line"
fi

# Create backup
cp "$FILE" "${FILE}.backup"
echo "💾 Backup created: ${FILE}.backup"

# Replace existing $plugin->version = ...;
# More robust regex to handle various whitespace and formatting
if sed -i.tmp -E "s/(\\\$plugin->version[[:space:]]*=[[:space:]]*)[0-9]+([[:space:]]*;)/\1${VERSION_INT}\2/" "$FILE"; then
  rm -f "${FILE}.tmp"
  echo "✅ File updated successfully"
else
  echo "❌ sed command failed"
  # Restore backup
  mv "${FILE}.backup" "$FILE"
  exit 1
fi

# Verify the change was made
NEW_VERSION_LINE=$(grep -E '\$plugin->version\s*=' "$FILE" | head -1)
if [ -n "$NEW_VERSION_LINE" ]; then
  echo "📋 New version line: $NEW_VERSION_LINE"

  # Check if the new version is actually in the file
  if grep -q "$VERSION_INT" "$FILE"; then
    echo "✅ Version successfully updated to $VERSION_INT"

    # Show the diff for verification
    echo ""
    echo "🔄 Changes made:"
    diff "${FILE}.backup" "$FILE" || true

    # Clean up backup
    rm -f "${FILE}.backup"
  else
    echo "❌ Version update failed - $VERSION_INT not found in file"
    # Restore backup
    mv "${FILE}.backup" "$FILE"
    exit 1
  fi
else
  echo "❌ Could not find version line after update"
  # Restore backup
  mv "${FILE}.backup" "$FILE"
  exit 1
fi

echo ""
echo "📄 Final file content:"
cat "$FILE"
