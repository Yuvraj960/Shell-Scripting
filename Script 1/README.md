# Disk Space Monitor

A robust bash script for monitoring disk space usage and identifying large files and directories that might be consuming excessive space. This tool provides automated scanning with intelligent timeout handling and generates cleanup suggestions to help manage disk space efficiently.

## Features

- **Disk Usage Summary**: Visualizes disk usage with color-coded output based on threshold levels
- **Large File Detection**: Identifies the top space-consuming files in the specified directory
- **Large Directory Detection**: Finds directories that take up significant disk space
- **Smart Exclusion System**: Automatically excludes system directories to focus on user data
- **Timeout Handling**: Prevents scans from running indefinitely with configurable timeout limits
- **Progress Indicators**: Shows scan progress during execution
- **Cleanup Suggestions**: Provides actionable recommendations based on scan results
- **Detailed Logging**: Maintains a log file of all operations for reference

## Requirements

- Bash shell (version 4.0+)
- Standard Unix utilities: `find`, `du`, `sort`, `awk`, `df`, `tee`, `kill`

## Installation

1. Download the script:
   ```bash
   curl -O https://example.com/disk_monitor.sh
   ```
   or copy the script content to a new file.

2. Make the script executable:
   ```bash
   chmod +x disk_monitor.sh
   ```

3. Optionally, move to a directory in your PATH for easier access:
   ```bash
   sudo mv disk_monitor.sh /usr/local/bin/disk_monitor
   ```

## Configuration

You can customize the script by editing the configuration variables at the top:

| Variable | Description | Default |
|----------|-------------|---------|
| `THRESHOLD` | Disk usage percentage threshold for alerts | 80 |
| `TOP_ITEMS` | Number of top items to display | 5 |
| `LOG_FILE` | Path to log file | `$HOME/disk_monitor.log` |
| `SCAN_DIR` | Directory to scan | `$HOME` |
| `TIMEOUT` | Maximum time in seconds for each scan | 30 |
| `EXCLUDE_PATHS` | Array of paths to exclude from scanning | Various system directories |

## Usage

Run the script without any parameters:

```bash
./disk_monitor.sh
```

The script will:
1. Check disk usage across all mounted filesystems
2. Highlight filesystems exceeding the threshold
3. Scan for the largest files in the configured directory
4. Identify the largest directories
5. Provide cleanup suggestions based on scan results
6. Log all operations to the configured log file

## Output Example

```
========================================
     Disk Space Monitor - 2025-04-20 15:30:45
     Alert threshold: 80%
     Log file: /home/user/disk_monitor.log
     Scanning: /home/user
     Timeout: 30s per scan
========================================

Disk Usage Summary:
------------------
Filesystem           Size     Used    Avail Use% Mounted on
/dev/sda1            100G     85G     15G   85%  /
/dev/sdb1            500G    350G    150G   70%  /data

Scanning for large files (timeout: 30s)...
----------------------------------------
....................
Scan completed in 20s. Top 5 largest files:
----------------------------------------
1.2G    /home/user/Downloads/ubuntu-22.04-desktop-amd64.iso
850M    /home/user/Videos/presentation.mp4
750M    /home/user/Documents/backup.tar.gz
540M    /home/user/Downloads/dataset.zip
320M    /home/user/Pictures/vacation_photos.zip

Scanning for large directories (timeout: 30s)...
----------------------------------------
.....................
Scan completed in 21s. Top 5 largest directories:
----------------------------------------
3.5G    /home/user/Downloads
2.8G    /home/user/Videos
1.9G    /home/user/Documents
1.5G    /home/user/Pictures
950M    /home/user/.cache

Recommended Cleanup Actions:
--------------------------
1. Clear your temporary files:
   rm -rf ~/tmp/*
   rm -rf ~/.cache/*

2. Remove old downloads:
   ls -lh ~/Downloads/* | sort -k5 -rh | head -n 5

3. Check for large media files:
   find ~ -type f \( -name '*.mp4' -o -name '*.iso' -o -name '*.zip' \) -exec du -h {} + 2>/dev/null | sort -rh | head -n 5

4. Clean package cache:
   sudo apt clean       # Debian/Ubuntu
   sudo dnf clean all   # Fedora/RHEL

5. Remove old docker containers/images:
   docker system prune --all --volumes

NOTE: These are just suggestions. Review files before deleting!

========================================
Scan complete. Check /home/user/disk_monitor.log for details.
Never run deletion commands without reviewing files first!
========================================
```

## Safety Considerations

- The script does not automatically delete any files
- All cleanup suggestions require manual review and execution
- System directories are excluded by default to prevent accidental deletion
- Always review the suggested files before removing them

## Logging

The script creates a log file at the location specified in the `LOG_FILE` variable. The log contains timestamps and details about the disk check operations performed.

## Customizing Scan Locations

To scan a different directory:

1. Edit the script and change the `SCAN_DIR` variable:
   ```bash
   SCAN_DIR="/path/to/directory"
   ```

2. Or, modify the script to accept a command-line parameter for the scan directory.

## Troubleshooting

- **Slow Scans**: Increase the `TIMEOUT` value for larger directories
- **Missing Results**: Check if the directory permissions allow the script to access all files
- **Script Terminating Early**: The timeout might be too short; increase the `TIMEOUT` value

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
