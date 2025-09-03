#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 <project-name>"
	exit 1
fi

PROJECT_NAME="$1"

# Create Vite React project (suppress output)
npm create vite@latest "$PROJECT_NAME" -- --template react > /dev/null 2>&1
cd "$PROJECT_NAME" || exit 1

# Clear App.jsx
> src/App.jsx

# Clear index.css
> src/index.css

# Delete App.css
rm -f src/App.css

# Delete vite.svg from public
rm -f public/vite.svg

# Delete react.svg from assets
rm -f src/assets/react.svg

 # Install all dependencies
npm install > /dev/null 2>&1

# Clear README.md
> README.md

echo "Clean Setup for Vite React project '$PROJECT_NAME' done"
echo "Run 'npm run dev' to start the development server."