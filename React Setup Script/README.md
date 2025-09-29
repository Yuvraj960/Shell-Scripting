# React Setup Script

This repository contains a Bash script (`react.sh`) to quickly set up a clean Vite React project. The script automates the creation of a new React project using Vite, removes unnecessary files, and prepares the project for development.

## Features

- Creates a new Vite React project.
- Clears unnecessary files and boilerplate code:
  - Empties `src/App.jsx` and `src/index.css`.
  - Deletes `src/App.css`, `public/vite.svg`, and `src/assets/react.svg`.
- Installs all required dependencies.
- Provides a clean slate for starting your React project.

## Prerequisites

Ensure you have the following installed on your system:

- [Node.js](https://nodejs.org/) (v14 or higher recommended)
- [npm](https://www.npmjs.com/) (comes with Node.js)

## Usage

1. Open a terminal.
2. Navigate to the directory containing the `react.sh` script.
3. Run the script with the following command:

   ```bash
   ./react.sh <project-name>
   ```

   Replace `<project-name>` with the desired name of your React project.

4. The script will:
   - Create a new Vite React project in a folder named `<project-name>`.
   - Remove unnecessary files and boilerplate code.
   - Install all dependencies.

5. Once the script completes, navigate to the project directory:

   ```bash
   cd <project-name>
   ```

6. Start the development server:

   ```bash
   npm run dev
   ```

## Example

```bash
./react.sh my-react-app
```

This will create a new React project in the `my-react-app` directory, clean up unnecessary files, and install dependencies. You can then navigate to the `my-react-app` directory and start the development server.

## Notes

- The script suppresses output for most commands to keep the terminal clean. If you encounter any issues, you can modify the script to remove the `> /dev/null 2>&1` parts to see detailed output.
- Ensure the script has executable permissions. If not, run:

  ```bash
  chmod +x react.sh
  ```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
