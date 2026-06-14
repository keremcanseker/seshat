#!/usr/bin/env bash
# One command to cut a release locally: build + notarize the DMG (scripts/release.sh)
# then upload it + a version manifest to R2, so the website download and the
# in-app update banner go live immediately. No CI / GitHub secrets needed —
# notarization runs on this Mac with your keychain profile.
#
# Setup once: copy your creds into scripts/release.env (gitignored), e.g.
#   DEVELOPER_ID="Developer ID Application: Your Name (TEAMID)"
#   TEAM_ID="XXXXXXXXXX"
#   NOTARY_PROFILE="seshat-notarize"
#   S3_ENDPOINT="https://<accountid>.r2.cloudflarestorage.com"
#   S3_BUCKET="seshat-downloads"
#   S3_REGION="auto"
#   S3_ACCESS_KEY_ID="..."
#   S3_SECRET_ACCESS_KEY="..."
#
# The version is derived automatically from git (0.<minor>.<commit count>) by
# release.sh, so there's nothing to bump — just commit your work and run:
#   scripts/publish.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="$ROOT/dist"

# Load local creds if present.
if [ -f "$ROOT/scripts/release.env" ]; then
    set -a
    # shellcheck disable=SC1091
    . "$ROOT/scripts/release.env"
    set +a
fi

: "${S3_ENDPOINT:?set S3_ENDPOINT (scripts/release.env)}"
: "${S3_BUCKET:?set S3_BUCKET}"
: "${S3_ACCESS_KEY_ID:?set S3_ACCESS_KEY_ID}"
: "${S3_SECRET_ACCESS_KEY:?set S3_SECRET_ACCESS_KEY}"

if ! command -v aws >/dev/null 2>&1; then
    echo "error: aws CLI not installed (brew install awscli)" >&2
    exit 1
fi

# 1. Build + sign + notarize → dist/Seshat.dmg
bash "$ROOT/scripts/release.sh"

DMG="$DIST/Seshat.dmg"
[ -f "$DMG" ] || { echo "error: $DMG not produced" >&2; exit 1; }
VERSION="$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$DIST/Seshat.app/Contents/Info.plist")"

# 2. Version manifest the server's /version reads.
printf '{"version":"%s","notes":null}\n' "$VERSION" > "$DIST/latest.json"

# 3. Upload (stable keys, overwritten = always latest).
export AWS_ACCESS_KEY_ID="$S3_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$S3_SECRET_ACCESS_KEY"
export AWS_DEFAULT_REGION="${S3_REGION:-auto}"

echo "› uploading to R2 bucket '$S3_BUCKET'"
aws s3 cp "$DMG" "s3://$S3_BUCKET/Seshat.dmg" \
    --endpoint-url "$S3_ENDPOINT" \
    --content-type application/x-apple-diskimage \
    --cache-control "public, max-age=300"
aws s3 cp "$DIST/latest.json" "s3://$S3_BUCKET/latest.json" \
    --endpoint-url "$S3_ENDPOINT" \
    --content-type application/json \
    --cache-control "no-cache"

echo ""
echo "✓ published Seshat $VERSION to R2 — download + in-app update are now live"
