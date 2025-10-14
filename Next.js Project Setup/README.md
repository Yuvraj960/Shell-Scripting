# Next.js Project Setup

This repository contains a Bash script (`setup.sh`) to quickly set up a clean Next.js project with sensible defaults. The script automates the creation of a new Next.js project using `create-next-app`, removes unnecessary files, and prepares the project for development with a minimal "Hello World" setup.

## Features

- Creates a new Next.js project with the following configuration:
  - **JavaScript** (no TypeScript)
  - **ESLint** enabled
  - **Tailwind CSS** enabled
  - **src/ directory** structure
  - **App Router** (Next.js 13+ routing)
  - **Turbopack** for faster development builds
- Cleans up boilerplate files:
  - Empties `src/app/globals.css`
  - Deletes all files in `public/` directory
  - Removes `favicon.ico` from the app directory
- Creates a minimal "Hello World" component:
  - Creates `src/app/components/Hello.js` with a simple greeting
  - Updates `src/app/page.js` to display the Hello component centered on the page
- Logs all command output to a timestamped log file for debugging
- Provides a clean starting point for Next.js development

## Prerequisites

Ensure you have the following installed on your system:

- [Node.js](https://nodejs.org/) (v18 or higher recommended)
- [npm](https://www.npmjs.com/) (comes with Node.js)
- [npx](https://www.npmjs.com/package/npx) (comes with npm)

## Usage

1. Open a terminal.
2. Navigate to the directory containing the `setup.sh` script.
3. Run the script with the following command:

   ```bash
   ./setup.sh <project-name>
   ```

   Replace `<project-name>` with the desired name of your Next.js project. If no name is provided, it defaults to `my-next-app`.

4. The script will:
   - Create a new Next.js project in a folder named `<project-name>`.
   - Configure the project with JavaScript, ESLint, Tailwind CSS, src/ directory, App Router, and Turbopack.
   - Remove unnecessary boilerplate files.
   - Create a simple "Hello World" component and page.
   - Log all operations to a timestamped log file.

5. Once the script completes, navigate to the project directory:

   ```bash
   cd <project-name>
   ```

6. Start the development server:

   ```bash
   npm run dev
   ```

7. Open your browser and visit `http://localhost:3000` to see your Next.js app with "Hello world from Next JS" displayed in the center of the page.

## Example

```bash
./setup.sh my-nextjs-app
```

This will create a new Next.js project in the `my-nextjs-app` directory, clean up unnecessary files, create a minimal Hello World component, and prepare the project for development. You can then navigate to the `my-nextjs-app` directory and start the development server.

## What the Script Does

The script performs the following steps:

1. **Pre-checks**: Verifies that Node.js, npm, and npx are installed.

2. **Project Creation**: Runs `npx create-next-app@latest` with the following options:
   - `--js`: Use JavaScript instead of TypeScript
   - `--eslint`: Enable ESLint for code quality
   - `--tailwind`: Include Tailwind CSS for styling
   - `--src-dir`: Use the `src/` directory structure
   - `--app`: Use the App Router (Next.js 13+ feature)
   - `--turbopack`: Enable Turbopack for faster development builds
   - `--yes`: Accept all defaults for non-specified options

3. **Cleanup**:
   - Deletes all files in the `public/` directory
   - Removes `favicon.ico` from various potential locations
   - Empties `src/app/globals.css` to start with a clean stylesheet

4. **Component Setup**:
   - Creates `src/app/components/Hello.js` with a simple greeting component
   - Replaces `src/app/page.js` to render the Hello component centered both horizontally and vertically

5. **Completion**: Displays the project location and next steps to run the development server.

## Notes

- All command output is logged to a timestamped file (e.g., `setup_my-next-app_20241014_143000.log`) for debugging purposes.
- The script uses error handling to ensure all required tools are available before starting.
- If you encounter any issues, check the log file for detailed error messages.
- Ensure the script has executable permissions. If not, run:

  ```bash
  chmod +x setup.sh
  ```

## License

This project is licensed under the MIT License. See the [LICENSE](../LICENSE) file for details.
