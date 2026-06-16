# deploy_agent_YourUsername

A shell script that bootstraps a Student Attendance Tracker workspace by copying
provided source files into the correct project structure.

---

## Repository Structure

```
deploy_agent_yourusername/
├── setup_project.sh       ← the bootstrap script
├── attendance_checker.py  ← provided source (gets copied)
├── assets.csv             ← provided source (gets copied)
├── config.json            ← provided source (gets copied)
├── reports.log            ← provided source (gets copied)
└── README.md
```

---

## How to Run

```bash
# 1. Clone the repo
git clone https://github.com/yourusername/deploy_agent_yourusername.git
cd deploy_agent_yourusername

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
