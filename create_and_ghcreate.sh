#!/usr/bin/env bash
set -euo pipefail

# Run this from the parent workspace. This environment may not have Flutter/GitHub CLI installed.
TARGET="${1:-$HOME/workspace/projects/irkop-belajar-tk}"
REPO="irkop-belajar-tk"

mkdir -p "$(dirname "$TARGET")"
if [ ! -d "$TARGET/.git" ]; then
  git init "$TARGET"
fi
cd "$TARGET"

echo "Project files should be copied here before this script is run."

if command -v gh >/dev/null 2>&1; then
  gh repo create "$REPO" --source=. --public --push
else
  echo "GitHub CLI (gh) tidak tersedia. Install/login gh lalu jalankan:"
  echo "  cd $TARGET"
  echo "  gh repo create $REPO --source=. --public --push"
fi
