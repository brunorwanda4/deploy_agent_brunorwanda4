#!/usr/bin/env bash

input=""
DIR=""
ARCHIVE=""

cleanup() {
    echo ""
    echo "Interrupted! Saving progress..."

    if [ -n "$DIR" ] && [ -d "$DIR" ]; then
        ARCHIVE="${DIR}_archive.tar.gz"
        tar -czf "$ARCHIVE" "$DIR" 2>/dev/null
        rm -rf "$DIR"
        echo "Saved to: $ARCHIVE"
        echo "Removed incomplete directory: $DIR"
    else
        echo "No project directory was created yet."
    fi

    exit 1
}

trap cleanup SIGINT

read -r -p "Project name: " input

if [ -z "$input" ]; then
    echo "Need a project name"
    exit 1
fi

DIR="attendance_tracker_${input}"

if [ -e "$DIR" ]; then
    echo "Directory already exists: $DIR"
    echo "Choose a different project name or remove the existing directory."
    exit 1
fi

echo "Setting up $DIR..."

mkdir -p "$DIR/Helpers" "$DIR/reports"

cp attendance_checker.py "$DIR/"
cp assets.csv "$DIR/Helpers/"
cp config.json "$DIR/Helpers/"
cp reports.log "$DIR/reports/"

echo ""
read -r -p "Change attendance thresholds? (y/n): " change_thresh

read_threshold() {
    local prompt="$1" value
    while true; do
        read -r -p "$prompt" value
        if [ -z "$value" ]; then
            # empty -> keep default
            printf '%s' ""
            return 0
        fi
        if [[ "$value" =~ ^[0-9]+$ ]] && [ "$value" -ge 1 ] && [ "$value" -le 100 ]; then
            printf '%s' "$value"
            return 0
        fi
        echo "  Invalid: enter a whole number from 1 to 100 (or leave blank)." >&2
    done
}

if [ "$change_thresh" = "y" ] || [ "$change_thresh" = "Y" ]; then
    new_warn=$(read_threshold "  Warning threshold % (default 75): ")
    new_fail=$(read_threshold "  Failure threshold % (default 50): ")

    if [ -n "$new_warn" ]; then
        sed -i.bak "s/\"warning\": [0-9]*/\"warning\": $new_warn/" "$DIR/Helpers/config.json"
    fi
    if [ -n "$new_fail" ]; then
        sed -i.bak "s/\"failure\": [0-9]*/\"failure\": $new_fail/" "$DIR/Helpers/config.json"
    fi
    rm -f "$DIR/Helpers/config.json.bak"
    echo "Config updated."
fi

echo ""
echo "Checking environment..."

if python3 --version 2>/dev/null; then
    echo "Python3 found - good."
else
    echo "Warning: python3 not installed."
fi

echo ""
echo "Verifying structure..."
all_good=true

check_file() {
    if [ -f "$1" ]; then
        echo "  [OK] $1"
    else
        echo "  [MISSING] $1"
        all_good=false
    fi
}

check_file "$DIR/attendance_checker.py"
check_file "$DIR/Helpers/assets.csv"
check_file "$DIR/Helpers/config.json"
check_file "$DIR/reports/reports.log"

if $all_good; then
    echo ""
    echo "Setup done! Run with:"
    echo "  cd $DIR && python3 attendance_checker.py"
    trap - SIGINT
else
    echo ""
    echo "Some files missing - check above"
    exit 1
fi
