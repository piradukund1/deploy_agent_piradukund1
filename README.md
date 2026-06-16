# deploy_agent_piradukund1

A shell script that bootstraps a Student Attendance Tracker workspace by automatically creating the required directory structure, copying provided source files, configuring settings, and handling interruptions safely.

---

## Video Explanation

Google Drive: https://drive.google.com/file/d/1XLPYYz5gajPNK6eUm-oWu6xTf0nBKHbz/view?usp=drive_link

This video explains the project approach, script functionality, and execution process.

---
## Repository Structure

```
deploy_agent_piradukund1/
├── setup_project.sh       ← the bootstrap script
├── attendance_checker.py  ← provided on canvas
├── assets.csv             ← provided 
├── config.json            ← provided 
├── reports.log            ← provided 
└── README.md
```

---

## How to Run

```bash
# 1. Clone the repo
git clone https://github.com/piradukund1/deploy_agent_piradukund1.git
cd deploy_agent_piradukund1

# 2. Make the script executable
chmod +x setup_project.sh

# 3. Run it
./setup_project.sh
```

You will be prompted to:
1. Enter a project suffix (e.g. `v1`) → creates `attendance_tracker_v1/`
2. Optionally update the Warning and Failure attendance thresholds

---

## Output Structure Created

```
attendance_tracker_{input}/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
└── reports/
    └── reports.log
```

---

## How to Trigger the Archive (Trap Feature)

Press **Ctrl+C** at any point while the script is running.

The SIGINT trap will:
1. Bundle whatever has been created so far into `attendance_tracker_{input}_archive.tar.gz`
2. Delete the incomplete project directory to keep the workspace clean
3. Exit gracefully

To test it deliberately, run the script and press Ctrl+C after the directory is created
but before setup finishes.

---

## Requirements

| Tool     | Purpose                          |
|----------|----------------------------------|
| `bash`   | Script interpreter               |
| `python3`| Run the tracker after setup      |
| `tar`    | Create the archive on Ctrl+C     |
| `sed`    | In-place config file editing     |
