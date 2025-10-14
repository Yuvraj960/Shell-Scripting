#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME=${1:-my-next-app}
LOG_FILE="setup_${PROJECT_NAME}_$(date +%Y%m%d_%H%M%S).log"

echo "==> Creating Next.js app: ${PROJECT_NAME}"
echo "==> Logging all command output to: ${LOG_FILE}"

# Basic prechecks
if ! command -v node >/dev/null 2>&1; then
	echo "Error: Node.js is not installed. Please install Node.js (v18+) and retry." >&2
	exit 1
fi
if ! command -v npm >/dev/null 2>&1; then
	echo "Error: npm is not available. Please install npm and retry." >&2
	exit 1
fi
if ! command -v npx >/dev/null 2>&1; then
	echo "Error: npx is not available. Please ensure npm is correctly installed." >&2
	exit 1
fi

# Create the app non-interactively with required options.
# Notes:
# - --js forces JavaScript (no TypeScript)
# - --yes avoids additional prompts (defaults will be used for anything not specified)
echo "==> Running create-next-app with required options..."
npx create-next-app@latest "${PROJECT_NAME}" \
  --yes \
  --js \
  --eslint \
  --tailwind \
  --src-dir \
  --app \
  --turbopack >> "${LOG_FILE}" 2>&1

PROJECT_DIR="${PROJECT_NAME}"
if [[ ! -f "${PROJECT_DIR}/package.json" ]]; then
	echo "Error: Project did not generate correctly (missing package.json)." >&2
	exit 1
fi

echo "==> Project scaffolded. Applying post-creation customizations..."

# 1) Delete contents of public/
if [[ -d "${PROJECT_DIR}/public" ]]; then
  rm -rf "${PROJECT_DIR}/public"/* >> "${LOG_FILE}" 2>&1 || true
fi

# 2) Delete favicon.ico where create-next-app places it for app router
#    Typically at src/app/favicon.ico (since we used --src-dir)
rm -f "${PROJECT_DIR}/src/app/favicon.ico" \
      "${PROJECT_DIR}/app/favicon.ico" \
      "${PROJECT_DIR}/public/favicon.ico" >> "${LOG_FILE}" 2>&1 || true

# Determine app paths (we used --src-dir, but handle fallback just in case)
APP_DIR="${PROJECT_DIR}/src/app"
if [[ ! -d "${APP_DIR}" ]]; then
	APP_DIR="${PROJECT_DIR}/app"
fi

GLOBAL_CSS_FILE="${APP_DIR}/globals.css"
PAGE_FILE="${APP_DIR}/page.js"
COMP_DIR="${APP_DIR}/components"
HELLO_FILE="${COMP_DIR}/Hello.js"

# 3) Empty globals.css if present
if [[ -f "${GLOBAL_CSS_FILE}" ]]; then
	: > "${GLOBAL_CSS_FILE}"
fi

# Ensure components directory exists
mkdir -p "${COMP_DIR}"

# 4) Create Hello component (server component by default)
cat > "${HELLO_FILE}" << 'EOF'
export default function Hello() {
	return (
		<div style={{ fontSize: '1.5rem', fontWeight: 600 }}>Hello world from Next JS</div>
	);
}
EOF

# 5) Replace page.js to render the component centered both ways
if [[ -f "${PAGE_FILE}" ]]; then
  cat > "${PAGE_FILE}" << 'EOF'
import Hello from './components/Hello';

export default function Home() {
  return (
    <main
      style={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
      }}
    >
      <Hello />
    </main>
  );
}
EOF
else
  echo "Warning: ${PAGE_FILE} not found; attempting to locate page file..." >&2
  # Try common alternatives (rare for JS choice, but handle defensively)
  if [[ -f "${APP_DIR}/page.jsx" ]]; then
    PAGE_FILE="${APP_DIR}/page.jsx"
    cat > "${PAGE_FILE}" << 'EOF'
import Hello from './components/Hello';

export default function Home() {
  return (
    <main
      style={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
      }}
    >
      <Hello />
    </main>
  );
}
EOF
  else
    echo "Error: Could not find a page file (page.js or page.jsx)." >&2
    exit 1
  fi
fi

echo "==> Done! Customized Next.js app is ready at: ${PROJECT_DIR}"
echo "==> All command output logged to: ${LOG_FILE}"
echo ""
echo "Next steps:"
echo "  cd \"${PROJECT_DIR}\""
echo "  npm run dev"
