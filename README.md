# deploy_agent_brunorwanda4

Automated project bootstrapping script for the Student Attendance Tracker.

## How to Run

```bash
chmod +x setup_project.sh
./setup_project.sh
```

Enter a project name when prompted. For example, if you enter `demo`, the script creates:

```text
attendance_tracker_demo/
```

## Directory Structure Created

```text
attendance_tracker_{name}/
|-- attendance_checker.py
|-- Helpers/
|   |-- assets.csv
|   `-- config.json
`-- reports/
    `-- reports.log
```

## Updating Thresholds

When prompted, enter `y` to change the attendance thresholds:

- Warning threshold (default: 75%)
- Failure threshold (default: 50%)

The script uses `sed` to update `config.json` in-place with the new values.

## Archive Feature (Ctrl+C)

Press Ctrl+C during setup. The script will:

1. Archive the current state to `attendance_tracker_{name}_archive.tar.gz`
2. Remove the incomplete `attendance_tracker_{name}` directory

This keeps the workspace clean.

## Health Check

Before finishing, the script runs:

```bash
python3 --version
```

If Python 3 is installed, it prints a success message. If Python 3 is missing, it prints a warning.

## Running the Attendance Checker

After setup:

```bash
cd attendance_tracker_{name}
python3 attendance_checker.py
```

## Run-through Video

Add your video link here before submitting:

```text
Video link: PASTE_YOUR_VIDEO_LINK_HERE
```

Suggested video flow:

1. Show the original files: `attendance_checker.py`, `assets.csv`, `config.json`, and `reports.log`.
2. Run `./setup_project.sh` and enter a project name.
3. Choose `y` for threshold updates and show that `Helpers/config.json` changed.
4. Run `python3 attendance_checker.py` inside the generated folder.
5. Run the script again and press Ctrl+C to show the archive file is created.
