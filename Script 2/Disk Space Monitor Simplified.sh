#!/bin/bash

# Simple Disk Space Monitor with Resizable Dialog GUI
# Version 2.1 - Adjustable Window Size

# Configuration
THRESHOLD=80                  # Warning threshold percentage
LOG_FILE="$HOME/disk_log.txt"  # Log file location
TEMP_FILE=$(mktemp)           # Temporary file for dialog content
HEIGHT=25                     # Dialog window height (lines)
WIDTH=80                      # Dialog window width (columns)

# Check if dialog is installed
check_dialog() {
    if ! command -v dialog &> /dev/null; then
        echo "Error: dialog package is required. Install with:"
        echo "sudo apt install dialog   # Debian/Ubuntu"
        echo "sudo dnf install dialog   # Fedora/RHEL"
        exit 1
    fi
}

# Function to create header separator
separator() {
    echo "=================================================="
}

# Check disk space and create report
check_disks() {
    separator
    echo "Disk Space Report - $(date '+%Y-%m-%d %H:%M:%S')"
    separator
    
    # Display disk space in table format (filter system partitions)
    echo "Filesystem        Total  Used  Free  Use% Mounted on"
    df -h -x tmpfs -x devtmpfs -x squashfs | \
    awk 'NR>1 && $6 !~ /\/boot|\/snap|\/dev|\/sys/ {printf "%-15s %5s %5s %5s %4s %s\n", $1, $2, $3, $4, $5, $6}'
    
    separator
    echo "Checking for disks over ${THRESHOLD}% usage..."
    
    # Check for threshold exceedance
    df -h | awk -v th="$THRESHOLD" 'NR>1 {
        gsub(/%/,"",$5); 
        if($5 > th && $6 !~ /\/boot|\/snap|\/dev|\/sys/) print "WARNING: " $6 " is " $5 "% full!"
    }'
}

# Basic cleanup suggestions
cleanup_tips() {
    separator
    echo "Cleanup Suggestions:"
    echo "1. Remove temporary files:        rm -rf /tmp/*"
    echo "2. Clear package manager cache:   sudo apt clean (Ubuntu) or sudo dnf clean all (Fedora)"
    echo "3. Check large home directories:  du -h --max-depth=1 $HOME | sort -h"
    echo "4. Remove old log files:          sudo journalctl --vacuum-size=200M"
    echo "5. Uninstall unused applications"
    separator
}

# Main script
main() {
    check_dialog  # Verify dialog is installed
    
    # Create log header
    echo -e "\n\n=== Disk Check at $(date) ===" > "$TEMP_FILE"
    
    # Run checks and store output
    {
        check_disks
        cleanup_tips
    } >> "$TEMP_FILE"
    
    # Show resizable dialog window
    dialog --title "Disk Space Monitor (${HEIGHT}x${WIDTH} Window)" \
           --textbox "$TEMP_FILE" \
           $HEIGHT $WIDTH \
           --no-collapse \
           --scrollbar
    
    # Save to log file
    cat "$TEMP_FILE" >> "$LOG_FILE"
    rm -f "$TEMP_FILE"
    
    # Show final message in terminal
    echo "Report saved to $LOG_FILE"
}

# Start the script
main