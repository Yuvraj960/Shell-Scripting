#!/bin/bash

# -------------------------------
# Upgrade All Outdated Pip Packages
# Clean and readable version
# -------------------------------

echo "----------------------------------------"
echo "Checking Python and pip availability..."
echo "----------------------------------------"

# Ensure python3 exists
if ! command -v python3 &> /dev/null
then
    echo "Error: python3 is not installed."
    exit 1
fi

# Ensure pip exists
if ! command -v pip &> /dev/null
then
    echo "Error: pip is not installed."
    exit 1
fi

echo "Python and pip detected."
echo ""

# Optional: upgrade pip itself first
echo "----------------------------------------"
echo "Upgrading pip to latest version..."
echo "----------------------------------------"
python3 -m pip install --upgrade pip

echo ""
echo "----------------------------------------"
echo "Getting list of outdated packages..."
echo "----------------------------------------"

# Get outdated packages in JSON format
OUTDATED_PACKAGES=$(pip list --outdated --format=json)

# Check if any packages are outdated
if [ "$OUTDATED_PACKAGES" = "[]" ]; then
    echo "All packages are already up to date."
    exit 0
fi

echo "Outdated packages found."
echo ""

echo "----------------------------------------"
echo "Upgrading packages one by one..."
echo "----------------------------------------"

# Pass JSON to Python for safe parsing and upgrading
python3 <<EOF
import json
import subprocess
import sys

packages = json.loads('''$OUTDATED_PACKAGES''')

print(f"Total outdated packages: {len(packages)}")
print("")

for pkg in packages:
    name = pkg["name"]
    current = pkg["version"]
    latest = pkg["latest_version"]

    print(f"Upgrading: {name}")
    print(f"  Current version: {current}")
    print(f"  Latest version : {latest}")

    subprocess.run(["pip", "install", "--upgrade", name])

    print(f"{name} upgraded successfully.")
    print("-" * 40)

print("")
print("All packages processed.")
EOF

echo ""
echo "----------------------------------------"
echo "Upgrade process completed."
echo "----------------------------------------"
