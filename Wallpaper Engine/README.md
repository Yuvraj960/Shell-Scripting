# Wallpaper Engine for Ubuntu Linux

This is a simple wallpaper engine for Ubuntu Linux that changes the wallpaper every hour. It uses a shell script and the system's cron scheduler to automate the process.

## Features
- Automatically changes the wallpaper every hour.
- Lightweight and efficient.
- Easy to set up and configure.

## Prerequisites
- Ubuntu Linux
- `cron` (usually pre-installed on Ubuntu)
- `gsettings` (used to change the wallpaper)

## Setup Instructions

1. Clone this repository or download the `wallpaper.sh` script to your desired location:

   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. Make the script executable:

   ```bash
   chmod +x wallpaper.sh
   ```

3. Edit your crontab to schedule the script:

   ```bash
   crontab -e
   ```

4. Add the following line to the crontab file to run the script every hour:

   ```
   0 * * * * /path/to/wallpaper.sh
   ```

   Replace `/path/to/wallpaper.sh` with the actual path to the script.

5. Save and exit the crontab editor. The script will now run every hour and change your wallpaper.

## Advantages
- No need to keep a process running.
- System handles scheduling.
- Logs can be configured separately.

## Notes
- Ensure that the `wallpaper.sh` script is properly configured to point to your wallpaper directory.
- Test the script manually to ensure it works as expected before adding it to the crontab.

## License
This project is licensed under the MIT License. Feel free to use and modify it as per your needs.
