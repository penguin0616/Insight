#!/usr/bin/env bash

# --- Configuration ---
# Get the absolute path of the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set SRC_INSIGHT to the parent directory of the script
DEFAULT_SRC="$(dirname "$SCRIPT_DIR")"

SRC_INSIGHT="${INSIGHT_SRC:-$DEFAULT_SRC}/"
STEAM_ROOT="${STEAM_PATH:-$HOME/.steam/steam/steamapps}"

# Target Paths
DS_TARGET="$STEAM_ROOT/common/dont_starve/mods/workshop-2081254154/"
DST_TARGET="$STEAM_ROOT/workshop/content/322330/2189004162/"

RSYNC_FLAGS="-rP -q --delete --exclude .git"

# --- Validation ---

DIR_NAME=$(basename "$SRC_INSIGHT")
if [[ "${DIR_NAME,,}" != "insight" ]]; then
    echo "Error: Source directory must be named 'insight' (found: '$DIR_NAME')."
    echo "Current path: $SRC_INSIGHT"
    exit 1
fi

# --- Functions ---

copy_insight_ds() {
    echo "Syncing Insight to Don't Starve [$DS_TARGET]"
    rsync $RSYNC_FLAGS "$SRC_INSIGHT" "$DS_TARGET"
}

copy_insight_dst() {
    echo "Syncing Insight to Don't Starve Together [$DST_TARGET]"
    rsync $RSYNC_FLAGS "$SRC_INSIGHT" "$DST_TARGET"
}

# --- Execution ---

echo "Insight Root: $SRC_INSIGHT"
echo "Steam Root: $STEAM_ROOT"

if command -v "luac5.1" &> /dev/null; then
	echo "Checking syntax of lua files..."
	if ! python3 -m "$(basename $SCRIPT_DIR).test_syntax"; then
		exit 1
	fi
else
	echo "[WARNING] Missing luac5.1, not checking syntax." >&2
fi

if command -v "klast" &> /dev/null; then
	echo "Generating missing assets..."
	if ! python3 -m "$(basename $SCRIPT_DIR).generate_assets"; then
		exit 1
	fi
else
	echo "[WARNING] Missing klast, not generating assets." >&2
fi

case "$1" in
    ds)      copy_insight_ds ;;
    dst)     copy_insight_dst ;;
    all|*)   copy_insight_ds; copy_insight_dst ;;
esac
