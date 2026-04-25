#!/usr/bin/env bash
# Evair APP (Flutter) — one-command "save everything".
# 1) Stages + commits + pushes to ALL git remotes (including Aliyun on a
#    non-overlapping branch to avoid clashing with the China team).
# 2) Rsyncs the working tree to the iCloud backup folder.
#
# Usage:
#   bash scripts/save.sh                # auto commit message (timestamp)
#   bash scripts/save.sh "message here" # custom message
#   bash scripts/save.sh --skip-if-clean

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ICLOUD_BACKUP="${HOME}/Library/Mobile Documents/com~apple~CloudDocs/EvairSIM-App-Backup"
# Aliyun policy: push `main` to a non-overlapping branch so we never touch
# the China team's branches. `feature/evairsim-jordan` was historically
# shared with them; they are now using it for the native app + chat work,
# so our WebView shell lives on a branch that is unambiguously ours.
ALIYUN_REMOTE="aliyun"
ALIYUN_BRANCH="feature/jordan-webview-shell"

cd "$PROJECT_DIR"

msg="${1:-}"
skip_if_clean=false
if [ "${msg}" = "--skip-if-clean" ]; then
  skip_if_clean=true
  msg=""
fi
if [ -z "${msg}" ]; then
  msg="save: $(date '+%Y-%m-%d %H:%M:%S')"
fi

branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "HEAD")
echo "────────────────────────────────────────"
echo "  Flutter APP save ($branch)"
echo "  dir:    $PROJECT_DIR"
echo "────────────────────────────────────────"

if git diff --quiet HEAD 2>/dev/null && [ -z "$(git ls-files --others --exclude-standard)" ]; then
  echo "  ✓ no local changes"
  if $skip_if_clean; then
    # Still rsync — the backup may have drifted even if git hasn't.
    :
  fi
else
  echo "  • staging all changes..."
  git add -A
  echo "  • committing: $msg"
  git commit -m "$msg" --quiet
fi

echo ""
echo "  • pushing to remotes..."
fail=0
while read -r remote; do
  [ -z "$remote" ] && continue
  if [ "$remote" = "$ALIYUN_REMOTE" ]; then
    target="$ALIYUN_BRANCH"
    echo "    → $remote ($branch → $target)"
    if ! git push "$remote" "$branch":"$target" 2>&1 | sed 's/^/      /'; then
      echo "      ✗ push to $remote failed"
      fail=1
    fi
  else
    echo "    → $remote ($branch)"
    if ! git push "$remote" "$branch" 2>&1 | sed 's/^/      /'; then
      echo "      ✗ push to $remote failed"
      fail=1
    fi
  fi
done <<< "$(git remote)"

echo ""
echo "  • rsyncing to iCloud backup..."
if [ -d "$ICLOUD_BACKUP" ] || mkdir -p "$ICLOUD_BACKUP"; then
  rsync -a --delete \
    --exclude='.git' --exclude='.dart_tool' --exclude='build' \
    --exclude='ios/Pods' --exclude='ios/.symlinks' \
    --exclude='android/.gradle' --exclude='android/build' --exclude='android/app/build' \
    "$PROJECT_DIR/" "$ICLOUD_BACKUP/"
  echo "    ✓ iCloud backup refreshed"
else
  echo "    ✗ iCloud backup folder unavailable"
  fail=1
fi

echo ""
if [ $fail -eq 0 ]; then
  echo "  ✓ Flutter save complete"
else
  echo "  ⚠ one or more steps failed — review output above"
  exit 1
fi
