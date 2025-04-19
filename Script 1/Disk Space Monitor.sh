#!/bin/bash

# Disk Space Monitor
# Improved version with better scanning and timeout handling

# Configuration
THRESHOLD=80
TOP_ITEMS=5
LOG_FILE="$HOME/disk_monitor.log"
SCAN_DIR="$HOME"
TIMEOUT=30  # Seconds for each scan

# Important directories to exclude
EXCLUDE_PATHS=(
    "/proc/*"
    "/sys/*"
    "/dev/*"
    "/run/*"
    "/boot/*"
    "/lost+found"
    "/var/lib/*"
    "/var/cache/*"
    "/usr/*"
    "/lib/*"
    "/lib64/*"
    "/bin/*"
    "/sbin/*"
    "/etc/*"
    "/root/*"
    "/tmp/*"
)

# Build find command exclusion options
build_exclusions() {
    local exclusions=()
    for path in "${EXCLUDE_PATHS[@]}"; do
        exclusions+=(-not -path "$path")
    done
    echo "${exclusions[@]}"
}

# Log function
log() {
    local message="[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    echo "$message" | tee -a "$LOG_FILE" 2>/dev/null || echo "$message (Log write failed)"
}

# Check disk space
check_disk_usage() {
    log "Checking disk space..."
    local alert_count=0
    
    echo -e "\nDisk Usage Summary:"
    echo "------------------"
    df -h | awk -v threshold="$THRESHOLD" -v green="\033[1;32m" -v red="\033[1;31m" -v reset="\033[0m" '
        BEGIN {
            printf "%-20s %8s %8s %8s %5s %s\n", "Filesystem", "Size", "Used", "Avail", "Use%", "Mounted on"
        }
        NR==1 {next}
        {
            use = $5+0
            if (use > threshold) {
                printf red
                alert_count++
            }
            else if (use > threshold-10) {
                printf green
            }
            printf "%-20s %8s %8s %8s %5s %s" reset "\n", $1, $2, $3, $4, $5, $6
        }
        END {
            exit (alert_count > 0 ? 1 : 0)
        }'
    
    return $?
}

# Find large files with timeout and iterative output
find_large_files() {
    log "Finding $TOP_ITEMS largest files in $SCAN_DIR..."
    local exclusions=$(build_exclusions)
    
    echo -e "\nScanning for large files (timeout: ${TIMEOUT}s)..."
    echo "----------------------------------------"
    
    # Run find in background to allow timeout
    (find "$SCAN_DIR" -type f $exclusions -exec du -h {} + 2>/dev/null | sort -rh | head -n "$TOP_ITEMS") &
    
    local pid=$!
    local counter=0
    
    # Show progress while waiting
    while kill -0 $pid 2>/dev/null && [ $counter -lt $TIMEOUT ]; do
        echo -n "."
        sleep 1
        ((counter++))
    done
    echo
    
    # Kill if still running after timeout
    if kill -0 $pid 2>/dev/null; then
        kill -9 $pid 2>/dev/null
        wait $pid 2>/dev/null
        echo -e "\nScan timed out after ${TIMEOUT}s. Showing partial results:"
    else
        echo -e "\nScan completed in ${counter}s. Top $TOP_ITEMS largest files:"
    fi
    
    # Show any results we got (from temp file)
    echo "----------------------------------------"
    local temp_file=$(mktemp)
    find "$SCAN_DIR" -type f $exclusions -exec du -h {} + 2>/dev/null | sort -rh | head -n "$TOP_ITEMS" > "$temp_file"
    cat "$temp_file"
    rm -f "$temp_file"
}

# Find large directories with timeout and iterative output
find_large_dirs() {
    log "Finding $TOP_ITEMS largest directories in $SCAN_DIR..."
    local exclusions=$(build_exclusions)
    
    echo -e "\nScanning for large directories (timeout: ${TIMEOUT}s)..."
    echo "----------------------------------------"
    
    # Run du in background to allow timeout
    (du -h --max-depth=1 $exclusions "$SCAN_DIR" 2>/dev/null | sort -rh | head -n "$((TOP_ITEMS+1))" | tail -n +2) &
    
    local pid=$!
    local counter=0
    
    # Show progress while waiting
    while kill -0 $pid 2>/dev/null && [ $counter -lt $TIMEOUT ]; do
        echo -n "."
        sleep 1
        ((counter++))
    done
    echo
    
    # Kill if still running after timeout
    if kill -0 $pid 2>/dev/null; then
        kill -9 $pid 2>/dev/null
        wait $pid 2>/dev/null
        echo -e "\nScan timed out after ${TIMEOUT}s. Showing partial results:"
    else
        echo -e "\nScan completed in ${counter}s. Top $TOP_ITEMS largest directories:"
    fi
    
    # Show any results we got (from temp file)
    echo "----------------------------------------"
    local temp_file=$(mktemp)
    du -h --max-depth=1 $exclusions "$SCAN_DIR" 2>/dev/null | sort -rh | head -n "$((TOP_ITEMS+1))" | tail -n +2 > "$temp_file"
    cat "$temp_file"
    rm -f "$temp_file"
}

# Generate safe cleanup suggestions
generate_cleanup_suggestions() {
    local full=$1
    
    echo -e "\nRecommended Cleanup Actions:"
    echo "--------------------------"
    
    echo "1. Clear your temporary files:"
    echo "   rm -rf ~/tmp/*"
    echo "   rm -rf ~/.cache/*"
    echo ""
    echo "2. Remove old downloads:"
    echo "   ls -lh ~/Downloads/* | sort -k5 -rh | head -n 5"
    echo ""
    
    if [ "$full" = true ]; then
        echo "3. Check for large media files:"
        echo "   find ~ -type f \( -name '*.mp4' -o -name '*.iso' -o -name '*.zip' \) -exec du -h {} + 2>/dev/null | sort -rh | head -n 5"
        echo ""
        echo "4. Clean package cache:"
        echo "   sudo apt clean       # Debian/Ubuntu"
        echo "   sudo dnf clean all   # Fedora/RHEL"
        echo ""
        echo "5. Remove old docker containers/images:"
        echo "   docker system prune --all --volumes"
    else
        echo "3. Disk space is not critical. No aggressive cleanup needed."
    fi
    
    echo -e "\nNOTE: These are just suggestions. Review files before deleting!"
}

# Main function
main() {
    clear
    echo "========================================"
    echo "     Disk Space Monitor - $(date)"
    echo "     Alert threshold: $THRESHOLD%"
    echo "     Log file: $LOG_FILE"
    echo "     Scanning: $SCAN_DIR"
    echo "     Timeout: ${TIMEOUT}s per scan"
    echo "========================================"
    
    echo "Starting disk space check..." > "$LOG_FILE"
    
    if ! check_disk_usage; then
        log "WARNING: One or more disks are above threshold ($THRESHOLD%)!"
        CRITICAL=true
    else
        log "Disk usage is below threshold ($THRESHOLD%)"
        CRITICAL=false
    fi
    
    find_large_files
    find_large_dirs
    generate_cleanup_suggestions $CRITICAL
    
    echo -e "\n========================================"
    echo "Scan complete. Check $LOG_FILE for details."
    echo "Never run deletion commands without reviewing files first!"
    echo "========================================"
}

# Run the script
main