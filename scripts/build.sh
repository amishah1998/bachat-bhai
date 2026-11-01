#!/usr/bin/env bash
# Regenerates AGENTS.md from the canonical skill and builds the upload zips.
# Usage: bash scripts/build.sh   (run from the pack root)
set -euo pipefail
cd "$(dirname "$0")/.."
SRC=skills/bachat-bhai/SKILL.md

{
  echo "<!-- Generated from $SRC by scripts/build.sh. Edit the skill, not this file. -->"
  echo "<!-- Bachat Bhai instructions for apps that read AGENTS.md or a system prompt file. Created by Ami and Karan. MIT License. -->"
  echo
  # strip YAML frontmatter (first block between --- lines)
  awk 'BEGIN{f=0} NR==1&&/^---$/{f=1;next} f==1&&/^---$/{f=2;next} f!=1{print}' "$SRC" | sed '1{/^$/d;}'
} > AGENTS.md

mkdir -p dist
rm -f dist/bachat-bhai-skill.zip
( cd skills && python3 -m zipfile -c ../dist/bachat-bhai-skill.zip bachat-bhai )
echo "Built AGENTS.md and dist/bachat-bhai-skill.zip"
