#!/usr/bin/env bash
# Publishes (or updates) the Assistive Technology Hub on GitHub Pages.
# Usage: ./deploy.sh [repo-name] [public|full]
#   public = tutorials only. data/students.xlsx is NOT uploaded.   <- default
#   full   = tutorials + students. Student data becomes public.
set -euo pipefail
cd "$(dirname "$0")"

REPO="${1:-assistive-technology-hub}"
MODE="${2:-public}"
[ "$MODE" = "public" ] || [ "$MODE" = "full" ] || { echo "Second argument must be 'public' or 'full'."; exit 1; }
[ -f data/tutorials.xlsx ] || { echo "Missing data/tutorials.xlsx"; exit 1; }
if [ "$MODE" = "full" ] && [ ! -f data/students.xlsx ]; then echo "Missing data/students.xlsx"; exit 1; fi

command -v git >/dev/null || { echo "Install git first: https://git-scm.com/downloads"; exit 1; }
command -v gh  >/dev/null || { echo "Install the GitHub CLI first: https://cli.github.com"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "Sign in first by running: gh auth login"; exit 1; }
gh auth setup-git

if [ "$MODE" = "full" ]; then
  echo "WARNING: GitHub Pages sites are public. 'full' puts student names and IEP"
  echo "supports on the open internet, and anyone can download students.xlsx."
  read -r -p "Type YES to continue anyway: " ok
  [ "$ok" = "YES" ] || { echo "Cancelled."; exit 1; }
fi

OWNER="$(gh api user --jq .login)"
BUILD="$(mktemp -d)"
cp index.html "$BUILD/"
cp -r vendor "$BUILD/vendor"
mkdir "$BUILD/data"
cp data/tutorials.xlsx "$BUILD/data/"
[ "$MODE" = "full" ] && cp data/students.xlsx "$BUILD/data/"
touch "$BUILD/.nojekyll"
cd "$BUILD"

git init -q -b main
git add .
git commit -q -m "Update Assistive Technology Hub ($MODE)"

if gh repo view "$OWNER/$REPO" >/dev/null 2>&1; then
  git remote add origin "https://github.com/$OWNER/$REPO.git"
  git push -q -f origin main
else
  gh repo create "$OWNER/$REPO" --public --source=. --remote=origin --push
fi

# Turn on GitHub Pages (ignored if it is already on)
gh api -X POST "repos/$OWNER/$REPO/pages" \
  -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 || true

echo
echo "Done. Changes can take 1-2 minutes to appear at:"
echo "https://$OWNER.github.io/$REPO/"
