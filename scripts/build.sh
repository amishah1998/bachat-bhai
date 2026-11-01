#!/usr/bin/env bash
# Regenerates AGENTS.md from the canonical skill and builds the upload zips.
# Usage: bash scripts/build.sh   (run from the pack root)
set -euo pipefail
cd "$(dirname "$0")/.."
SRC=skills/bachat-bhai/SKILL.md

# Build into temp files and rename at the end, so a failed run never leaves a
# truncated AGENTS.md or a missing zip behind.
mkdir -p dist
tmp_agents=$(mktemp AGENTS.md.XXXXXX)
tmp_zip=$(mktemp dist/bachat-bhai-skill.zip.XXXXXX)
trap 'rm -f "$tmp_agents" "$tmp_zip"' EXIT

{
  echo "<!-- Generated from $SRC by scripts/build.sh. Edit the skill, not this file. -->"
  echo "<!-- Bachat Bhai instructions for apps that read AGENTS.md or a system prompt file. Created by Ami and Karan. MIT License. -->"
  echo
  # strip YAML frontmatter (first block between --- lines)
  awk 'BEGIN{f=0} NR==1&&/^---$/{f=1;next} f==1&&/^---$/{f=2;next} f!=1{print}' "$SRC" | sed '1{/^$/d;}'
} > "$tmp_agents"

( cd skills && python3 -m zipfile -c "../$tmp_zip" bachat-bhai )

chmod 644 "$tmp_agents" "$tmp_zip"
mv "$tmp_agents" AGENTS.md
mv "$tmp_zip" dist/bachat-bhai-skill.zip
echo "Built AGENTS.md and dist/bachat-bhai-skill.zip"
