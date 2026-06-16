#!/bin/bash

read -p "Enter a project name suffix (e.g. v1): " INPUT

if [[ -z "$INPUT" ]]; then
    echo "Error: Project name cannot be empty."
    exit 1
fi

PROJECT_DIR="attendance_tracker_${INPUT}"

cleanup() {
    echo ""
    echo " Interrupt received! Archiving and cleaning up..."
    if [[ -d "$PROJECT_DIR" ]]; then
        tar -czf "attendance_tracker_${INPUT}_archive.tar.gz" "$PROJECT_DIR"
        rm -rf "$PROJECT_DIR"
        echo "Archive saved. Incomplete directory removed."
    fi
    exit 1
}

trap cleanup SIGINT

# Verify source files exist
for SRC in attendance_checker.py assets.csv config.json reports.log; do
    if [[ ! -f "$SCRIPT_DIR/$SRC" ]]; then
        echo " Missing source file: $SRC"
        exit 1
    fi
done

# Create structure
if [[ -d "$PROJECT_DIR" ]]; then
    read -p "Directory already exists. Overwrite? (y/n): " OW
    [[ "$OW" != "y" && "$OW" != "Y" ]] && { echo "Aborting."; exit 1; }
    rm -rf "$PROJECT_DIR"
fi

mkdir -p "$PROJECT_DIR/Helpers" "$PROJECT_DIR/reports"

# Copy files
cp "$SCRIPT_DIR/attendance_checker.py" "$PROJECT_DIR/attendance_checker.py"
cp "$SCRIPT_DIR/assets.csv"            "$PROJECT_DIR/Helpers/assets.csv"
cp "$SCRIPT_DIR/config.json"           "$PROJECT_DIR/Helpers/config.json"
cp "$SCRIPT_DIR/reports.log"           "$PROJECT_DIR/reports/reports.log"

echo "Files copied."

# Update thresholds
read -p "Update attendance thresholds? (y/n): " UPDATE
if [[ "$UPDATE" == "y" || "$UPDATE" == "Y" ]]; then
    while true; do
        read -p "Warning threshold % (default 75): " WARN
        WARN="${WARN:-75}"
        [[ "$WARN" =~ ^[0-9]+([.][0-9]+)?$ ]] && break
        echo "Must be numeric."
    done
    while true; do
        read -p "Failure threshold % (default 50): " FAIL
        FAIL="${FAIL:-50}"
        [[ "$FAIL" =~ ^[0-9]+([.][0-9]+)?$ ]] && break
        echo "Must be numeric."
    done

    CONFIG="$PROJECT_DIR/Helpers/config.json"
    sed -i "s/\"warning\": [0-9.]*/\"warning\": $WARN/" "$CONFIG"
    sed -i "s/\"failure\": [0-9.]*/\"failure\": $FAIL/" "$CONFIG"
    echo "Thresholds updated — Warning: ${WARN}%, Failure: ${FAIL}%"
fi

# Health check
PYTHON_VERSION=$(python3 --version 2>&1)

if [[ $? -eq 0 ]]; then
    echo " $PYTHON_VERSION"
else
    echo " Python3 not found."
fi

echo ""
echo " Done! Run: cd $PROJECT_DIR && python3 attendance_checker.py"