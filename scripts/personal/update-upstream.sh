#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
[[ $(git branch --show-current) == personal ]] || { echo 'Switch to personal first'; exit 1; }
[[ -z $(git status --porcelain) ]] || { echo 'Commit or stash your changes first'; exit 1; }
git fetch upstream main
# Deliberately leave the merge uncommitted for policy checks and human review.
git merge --no-ff --no-commit upstream/main
python3 scripts/personal/check-policy.py
printf '%s\n' 'Review the merge, run the manual build/tests, then git commit and git push origin personal.' 'To cancel the merge: git merge --abort'
