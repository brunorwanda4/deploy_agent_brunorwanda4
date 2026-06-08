#!/bin/bash

cleanup() {
    echo ""
    echo "Interrupted! Saving progress..."
    tar -czf "attendance_tracker_${input}_archive.tar.gz" "attendance_tracker_${input}" 2>/dev/null
    rm -rf "attendance_tracker_${input}"
    echo "Saved to: attendance_tracker_${input}_archive.tar.gz"
    exit 1
}

trap cleanup SIGINT

read -p "Project name: " input

if [ -z "$input" ]; then
    echo "Need a project name"
    exit 1
fi

DIR="attendance_tracker_${input}"

echo "Setting up $DIR..."

mkdir "$DIR"
mkdir "$DIR/Helpers"
mkdir "$DIR/reports"

cp attendance_checker.py "$DIR/"
cp assets.csv "$DIR/Helpers/"
cp reports.log "$DIR/reports/"

cat > "$DIR/Helpers/config.json" << 'CONF'
{
    "warning_threshold": 75,
    "failure_threshold": 50
}
CONF

echo ""
read -p "Change attendance thresholds? (y/n): " change_thresh

if [ "$change_thresh" = "y" ]; then
    read -p "  Warning threshold % (currently 75): " new_warn
    read -p "  Failure threshold % (currently 50): " new_fail

    if [ -n "$new_warn" ]; then
        sed -i "s/\"warning_threshold\": [0-9]*/\"warning_threshold\": $new_warn/" "$DIR/Helpers/config.json"
    fi
    if [ -n "$new_fail" ]; then
        sed -i "s/\"failure_threshold\": [0-9]*/\"failure_threshold\": $new_fail/" "$DIR/Helpers/config.json"
    fi
    echo "Config updated."
fi

echo ""
echo "Checking environment..."

if python3 --version 2>/dev/null; then
    echo "Python3 found - good"
else
    echo "Warning: python3 not installed"
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
else
    echo ""
    echo "Some files missing - check above"
fi
