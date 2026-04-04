#!/usr/bin/env bash
# fetch-from-gitlab.sh
# Downloads HackerNoon static assets from the GitLab hackernoon/creative repository
# into the correct subdirectories under files/templates/hackernoon-email-statics/
#
# Usage:
#   chmod +x fetch-from-gitlab.sh
#   ./fetch-from-gitlab.sh
#
# Requirements: curl, python3 (for JSON parsing), git
# GitLab API rate-limit: up to 10 req/s for unauthenticated requests.
# Set GITLAB_TOKEN to a personal access token to avoid rate-limiting.

set -euo pipefail

GITLAB_API="https://gitlab.com/api/v4"
PROJECT="hackernoon%2Fcreative"
REF="master"
DEST_ROOT="$(cd "$(dirname "$0")" && pwd)"

GITLAB_TOKEN="${GITLAB_TOKEN:-}"
AUTH_HEADER=""
if [[ -n "$GITLAB_TOKEN" ]]; then
  AUTH_HEADER="PRIVATE-TOKEN: $GITLAB_TOKEN"
fi

# Source folders and their local destinations
declare -A FOLDERS=(
  ["newsletters/logos/brand"]="$DEST_ROOT/newsletters/logos/brand"
  ["newsletters/logos/all"]="$DEST_ROOT/newsletters/logos/all"
  ["newsletters/logos/thematic/2021"]="$DEST_ROOT/newsletters/logos/thematic/2021"
  ["newsletters/memes/2021/Jan"]="$DEST_ROOT/newsletters/memes/2021/Jan"
)

curl_get() {
  local url="$1"
  if [[ -n "$AUTH_HEADER" ]]; then
    curl -sSfL -H "$AUTH_HEADER" "$url"
  else
    curl -sSfL "$url"
  fi
}

list_tree() {
  local path="$1"
  local encoded_path
  encoded_path=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$path', safe=''))")
  local url="$GITLAB_API/projects/$PROJECT/repository/tree?path=$encoded_path&ref=$REF&recursive=true&per_page=100"
  curl_get "$url"
}

download_file() {
  local file_path="$1"
  local dest_file="$2"
  local encoded_path
  encoded_path=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$file_path', safe=''))")
  local url="$GITLAB_API/projects/$PROJECT/repository/files/$encoded_path/raw?ref=$REF"
  mkdir -p "$(dirname "$dest_file")"
  curl_get "$url" -o "$dest_file"
  echo "  Downloaded: $(basename "$dest_file")"
}

echo "=== HackerNoon Static Assets Import from GitLab ==="
echo "Project : gitlab.com/hackernoon/creative"
echo "Branch  : $REF"
echo ""

total_files=0

for src_path in "${!FOLDERS[@]}"; do
  dest_dir="${FOLDERS[$src_path]}"
  echo "Fetching: $src_path"

  tree_json=$(list_tree "$src_path")
  files=$(echo "$tree_json" | python3 -c "
import json, sys
items = json.load(sys.stdin)
for item in items:
    if item['type'] == 'blob':
        print(item['path'])
")

  count=0
  while IFS= read -r file_path; do
    if [[ -z "$file_path" ]]; then continue; fi
    # Compute relative path under src_path
    rel="${file_path#$src_path/}"
    dest_file="$dest_dir/$rel"
    download_file "$file_path" "$dest_file"
    count=$((count + 1))
  done <<< "$files"

  # Remove .gitkeep placeholder if real files were downloaded
  if [[ $count -gt 0 && -f "$dest_dir/.gitkeep" ]]; then
    rm -f "$dest_dir/.gitkeep"
  fi

  echo "  → $count file(s) downloaded to $dest_dir"
  total_files=$((total_files + count))
  echo ""
done

echo "=== Import complete: $total_files file(s) downloaded ==="
