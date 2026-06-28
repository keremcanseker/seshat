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

# SwiftPM caches packages as bare git repos. If the machine's git has
# `safe.bareRepository=explicit` set (a hardening choice), xcodebuild can't
# resolve packages ("cannot use bare repository"). Allow it for this process's
# git subprocesses only, without touching the user's persistent config.
export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.bareRepository GIT_CONFIG_VALUE_0=all

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

# Version is derived from git so it never has to be hand-edited. The major.minor
# in project.yml's MARKETING_VERSION is the base ("0.2"); the patch is the total
# commit count, so every build that has new commits gets a strictly higher
# version and the in-app update banner fires for existing users. Passed as an
# xcodebuild override — project.yml is never mutated, so the tree stays clean.
# To start a new minor/major line, just edit the base in project.yml.
BASE_VERSION="$(grep -m1 'MARKETING_VERSION' project.yml | sed -E 's/.*"([0-9]+\.[0-9]+).*/\1/')"
COMMIT_COUNT="$(git -C "$ROOT" rev-list --count HEAD 2>/dev/null || echo 0)"
RESOLVED_VERSION="${BASE_VERSION:-0.0}.$COMMIT_COUNT"
echo "› version $RESOLVED_VERSION (base ${BASE_VERSION:-0.0} + $COMMIT_COUNT commits)"

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
    MARKETING_VERSION="$RESOLVED_VERSION" \
    CURRENT_PROJECT_VERSION="$COMMIT_COUNT" \
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

    # Sparkle ships a framework with nested helpers (XPC services, Updater.app,
    # Autoupdate). Every Mach-O / bundle must be Developer-ID signed with the
    # hardened runtime + a timestamp, deepest first, or notarization rejects the
    # app. The bundled CLI is a shell script (not Mach-O), so it needs no signing.
    SPARKLE_FW="$APP_PATH/Contents/Frameworks/Sparkle.framework"
    if [ -d "$SPARKLE_FW" ]; then
        echo "› signing Sparkle helpers"
        SPARKLE_VERSIONS="$SPARKLE_FW/Versions"
        VDIR="$(ls -d "$SPARKLE_VERSIONS"/*/ 2>/dev/null | grep -v Current | head -1)"
        for inner in \
            "$VDIR/XPCServices/Installer.xpc" \
            "$VDIR/XPCServices/Downloader.xpc" \
            "$VDIR/Updater.app" \
            "$VDIR/Autoupdate"; do
            [ -e "$inner" ] && codesign "${SIGN_ARGS[@]}" "$inner"
        done
        codesign "${SIGN_ARGS[@]}" "$SPARKLE_FW"
    fi

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

if [ -n "${DEVELOPER_ID:-}" ]; then
    echo "› signing DMG"
    codesign --force --sign "$DEVELOPER_ID" --timestamp "$DMG"

    if [ -n "${NOTARY_PROFILE:-}" ] || [ -n "${NOTARY_API_KEY_PATH:-}" ]; then
        echo "› notarizing DMG"
        if [ -n "${NOTARY_PROFILE:-}" ]; then
            xcrun notarytool submit "$DMG" --keychain-profile "$NOTARY_PROFILE" --wait
        else
            xcrun notarytool submit "$DMG" \
                --key "$NOTARY_API_KEY_PATH" \
                --key-id "$NOTARY_API_KEY_ID" \
                --issuer "$NOTARY_API_ISSUER_ID" \
                --wait
        fi
        xcrun stapler staple "$DMG"
    fi
fi

rm -rf "$STAGING"
rm -rf "$ARCHIVE"

echo ""
echo "✓ $DMG"
echo "✓ $APP_PATH"
ls -lh "$DMG" | awk '{print "  " $5 "  " $NF}'
