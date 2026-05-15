#!/usr/bin/env bash
# Check for new comments on tracked upstream issues.
# Usage: ./scripts/check-responses.sh
#
# Compares latest comment timestamps against a local snapshot
# (scripts/.last-check) and prints which issues have new activity.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="$SCRIPT_DIR/.last-check"
SELF="$SCRIPT_DIR/$(basename "${BASH_SOURCE[0]}")"

# Tracked issues: "repo issueNumber shortName"
TRACKED=(
  "projectnessie/nessie 10865 nessie-cli-stdout"
  "projectnessie/nessie 5349  nessie-docs-consistency"
  "argoproj/argo-cd     18198 argocd-request-timeout"
  "apache/polaris       1325  polaris-storage-docs"
  "kyverno/kyverno      16103 kyverno-certmanager"
  "projectnessie/nessie 12424 nessie-pr-5349"
  "kubeflow/spark-operator 2924 spark-operator-emptydir"
  "milvus-io/pymilvus 2724 pymilvus-pkg-resources"
  "apache/polaris 4451 polaris-pr-1325"
)

# Helper: add a new issue to the TRACKED array in this script.
# Usage: check-responses.sh add <owner/repo> <issueNumber> <shortName>
if [[ "${1:-}" == "add" ]]; then
  if [[ $# -ne 4 ]]; then
    echo "Usage: $0 add <owner/repo> <issueNumber> <shortName>"
    exit 1
  fi
  new_line="  \"$2 $3 $4\""
  if grep -qE "\"$2[[:space:]]+$3[[:space:]]" "$SELF"; then
    echo "Already tracked: $2#$3"
    exit 0
  fi
  # Insert before the closing ")" of TRACKED=(
  awk -v line="$new_line" '
    /^TRACKED=\(/  { in_block = 1; print; next }
    in_block && /^\)/ { print line; in_block = 0 }
    { print }
  ' "$SELF" > "$SELF.tmp" && mv "$SELF.tmp" "$SELF"
  chmod +x "$SELF"
  echo "Added: $2#$3 ($4)"
  exit 0
fi

NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)
NEW_ACTIVITY=0

mkdir -p "$SCRIPT_DIR"
touch "$STATE_FILE"

echo "Checking upstream issues at $NOW"
echo "================================================"

for entry in "${TRACKED[@]}"; do
  read -r repo issue name <<< "$entry"

  latest=$(gh issue view "$issue" --repo "$repo" \
    --json comments \
    --jq '.comments | sort_by(.createdAt) | last.createdAt // "none"' 2>/dev/null || echo "error")

  state=$(gh issue view "$issue" --repo "$repo" --json state --jq '.state' 2>/dev/null || echo "?")

  prev=$(grep -E "^$repo/$issue " "$STATE_FILE" 2>/dev/null | awk '{print $2}' || true)

  marker=""
  if [[ "$latest" != "none" && "$latest" != "error" && "$latest" != "$prev" ]]; then
    marker="  <-- NEW"
    NEW_ACTIVITY=$((NEW_ACTIVITY + 1))
  fi

  printf "[%-7s] %-40s %s%s\n" "$state" "$repo#$issue ($name)" "$latest" "$marker"
done

# Update snapshot
{
  for entry in "${TRACKED[@]}"; do
    read -r repo issue name <<< "$entry"
    latest=$(gh issue view "$issue" --repo "$repo" \
      --json comments --jq '.comments | sort_by(.createdAt) | last.createdAt // "none"' 2>/dev/null || echo "none")
    echo "$repo/$issue $latest"
  done
} > "$STATE_FILE"

echo "================================================"
if [[ "$NEW_ACTIVITY" -gt 0 ]]; then
  echo "$NEW_ACTIVITY issue(s) have new activity. Visit GitHub to read."
else
  echo "No new activity since last check."
fi
