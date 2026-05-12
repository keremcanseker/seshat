#!/usr/bin/env bash
# Build, sign, and package Seshat.app as a DMG.
#
# Optional env vars:
#   DEVELOPER_ID         "Developer ID Application: Name (TEAMID)" — full identity string
#   TEAM_ID              10-char Team ID — only used when DEVELOPER_ID is set
#   NOTARY_PROFILE       Keychain notarytool profile name (run `xcrun notarytool store-credentials` once)
#   NOTARY_API_KEY_PATH  Alternative to NOTARY_PROFILE — path to App Store Connect API key (.p8)
#   NOTARY_API_KEY_ID    Key ID for the API key
#   NOTARY_API_ISSUER_ID Issuer ID for the API key
#
# Without DEVELOPER_ID, the script ad-hoc signs (good for local testing,
# tripped by Gatekeeper on download — users need a one-time bypass).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="Seshat"
SCHEME="Seshat"
DIST="$ROOT/dist"
ARCHIVE="$DIST/$APP_NAME.xcarchive"
APP_PATH="$DIST/$APP_NAME.app"
STAGING="$DIST/dmg-staging"

cd "$ROOT/apps/macos"

if ! command -v xcodegen >/dev/null 2>&1; then
    echo "error: xcodegen not installed (brew install xcodegen)" >&2
    exit 1
fi

echo "› regenerating project"
xcodegen generate >/dev/null

rm -rf "$DIST"
mkdir -p "$DIST"

echo "› archiving (Release)"
xcodebuild \
    -project "$APP_NAME.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration Release \
    -archivePath "$ARCHIVE" \
    -destination 'generic/platform=macOS' \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGN_STYLE=Manual \
    DEVELOPMENT_TEAM="" \
    archive 2>&1 | grep -E "warning:|error:|ARCHIVE SUCCEEDED|ARCHIVE FAILED|^\*\*" || true

if [ ! -d "$ARCHIVE/Products/Applications/$APP_NAME.app" ]; then
    echo "error: archive did not produce $APP_NAME.app" >&2
    exit 1
fi

cp -R "$ARCHIVE/Products/Applications/$APP_NAME.app" "$APP_PATH"

if [ -n "${DEVELOPER_ID:-}" ]; then
    echo "› signing with Developer ID: $DEVELOPER_ID"
    SIGN_ARGS=(--force --options runtime --timestamp --sign "$DEVELOPER_ID")
    if [ -n "${TEAM_ID:-}" ]; then
        SIGN_ARGS+=(--identifier "com.keremcan.seshat")
    fi

    # Sign nested executables first (just the bundled CLI shell script — but it's not Mach-O,
    # so codesign is a no-op on it. Sign the app bundle itself.)
    codesign "${SIGN_ARGS[@]}" "$APP_PATH"
    codesign --verify --strict --verbose=2 "$APP_PATH"

    if [ -n "${NOTARY_PROFILE:-}" ] || [ -n "${NOTARY_API_KEY_PATH:-}" ]; then
        echo "› notarizing"
        NOTARIZE_ZIP="$DIST/$APP_NAME-notarize.zip"
        ditto -c -k --keepParent "$APP_PATH" "$NOTARIZE_ZIP"
        if [ -n "${NOTARY_PROFILE:-}" ]; then
            xcrun notarytool submit "$NOTARIZE_ZIP" --keychain-profile "$NOTARY_PROFILE" --wait
        else
            xcrun notarytool submit "$NOTARIZE_ZIP" \
                --key "$NOTARY_API_KEY_PATH" \
                --key-id "$NOTARY_API_KEY_ID" \
                --issuer "$NOTARY_API_ISSUER_ID" \
                --wait
        fi
        rm "$NOTARIZE_ZIP"
        xcrun stapler staple "$APP_PATH"
    else
        echo "› (no notarization — set NOTARY_PROFILE or NOTARY_API_KEY_* to enable)"
    fi
else
    echo "› ad-hoc signing (DEVELOPER_ID not set — Gatekeeper will warn on download)"
    codesign --force --sign - "$APP_PATH"
fi

VERSION="$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$APP_PATH/Contents/Info.plist")"
# Stable filename so the GitHub Releases /latest/download/ URL stays the same across versions.
# Version is captured in the release tag, not the file.
DMG="$DIST/$APP_NAME.dmg"

echo "› building DMG: $(basename "$DMG") (version $VERSION)"
rm -rf "$STAGING"
mkdir -p "$STAGING"
cp -R "$APP_PATH" "$STAGING/"
ln -s /Applications "$STAGING/Applications"

hdiutil create \
    -volname "$APP_NAME" \
    -srcfolder "$STAGING" \
    -ov \
    -format UDZO \
    "$DMG" >/dev/null

rm -rf "$STAGING"
rm -rf "$ARCHIVE"

echo ""
echo "✓ $DMG"
echo "✓ $APP_PATH"
ls -lh "$DMG" | awk '{print "  " $5 "  " $NF}'
