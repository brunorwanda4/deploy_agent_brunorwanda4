# deploy_agent_brunorwanda4

Automated project bootstrapping script for Student Attendance Tracker.

## How to Run

```bash
chmod +x setup_project.sh
./setup_project.sh
```

Enter a project name when prompted. The script creates `attendance_tracker_{name}/` with all required files.

## Directory Structure Created

```
attendance_tracker_{name}/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
└── reports/
    └── reports.log
```

## Updating Thresholds

When prompted, enter `y` to change the attendance thresholds:
- Warning threshold (default: 75%)
- Failure threshold (default: 50%)

The script uses `sed` to update `config.json` in-place with the new values.

## Archive Feature (Ctrl+C)

Press Ctrl+C at any point during setup. The script will:
1. Archive current state to `attendance_tracker_{name}_archive.tar.gz`
2. Remove the incomplete directory

This keeps the workspace clean.

## Running the Attendance Checker

After setup:

```bash
cd attendance_tracker_{name}
python3 attendance_checker.py
```
