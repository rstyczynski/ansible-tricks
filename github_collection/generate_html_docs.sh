#!/bin/bash
# generate_html_docs.sh - Generate HTML documentation for rstyczynski.github Collection
# Uses antsibull-docs as documented in:
# https://docs.ansible.com/projects/ansible/latest/dev_guide/developing_collections_documenting.html

set -e

COLLECTION_NAME="rstyczynski.github"
# Place documentation in collection's docs/ directory (Ansible standard)
COLLECTION_DOCS_DIR="collections/ansible_collections/rstyczynski/github/docs"
DEST_DIR="${COLLECTION_DOCS_DIR}/sphinx"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Generating HTML documentation for $COLLECTION_NAME Collection"
echo "======================================================================"
echo ""

# Check if antsibull-docs is installed
if ! command -v antsibull-docs &> /dev/null; then
    echo "❌ ERROR: antsibull-docs is not installed"
    echo ""
    echo "Install it with:"
    echo "  pip install antsibull-docs"
    echo ""
    echo "Or in a virtual environment:"
    echo "  python3 -m venv venv"
    echo "  source venv/bin/activate"
    echo "  pip install antsibull-docs"
    exit 1
fi

# Change to the script directory
cd "$SCRIPT_DIR"

# Set ANSIBLE_COLLECTIONS_PATH to point to collections directory
export ANSIBLE_COLLECTIONS_PATH="$SCRIPT_DIR/collections"

# Remove existing dest directory if it exists
if [ -d "$DEST_DIR" ]; then
    echo "Removing existing $DEST_DIR directory..."
    rm -rf "$DEST_DIR"
fi

# Create destination directory (antsibull-docs requires it to exist)
mkdir -p "$DEST_DIR"

# Step 1: Initialize the Sphinx documentation site
echo "Step 1: Initializing Sphinx documentation site..."
antsibull-docs sphinx-init --use-current --dest-dir "$DEST_DIR" "$COLLECTION_NAME"

if [ ! -d "$DEST_DIR" ]; then
    echo "❌ ERROR: Failed to create $DEST_DIR directory"
    exit 1
fi

# Step 2: Setup virtual environment (following ANSIBLE_BEST_PRACTICES.md)
echo ""
echo "Step 2: Setting up virtual environment..."
cd "$SCRIPT_DIR"

VENV_DIR=".venv"
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment in $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
fi

# Activate virtual environment
echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# Verify virtual environment is active
if [ -z "$VIRTUAL_ENV" ]; then
    echo "❌ ERROR: Failed to activate virtual environment"
    exit 1
fi

echo "Virtual environment activated: $VIRTUAL_ENV"

# Step 3: Install requirements
echo ""
echo "Step 3: Installing Python requirements..."
cd "$DEST_DIR"

if [ ! -f "requirements.txt" ]; then
    echo "❌ ERROR: requirements.txt not found in $DEST_DIR"
    exit 1
fi

pip install -q -r requirements.txt

# Step 4: Build the documentation
echo ""
echo "Step 4: Building HTML documentation..."
if [ ! -f "build.sh" ]; then
    echo "❌ ERROR: build.sh not found in $DEST_DIR"
    exit 1
fi

chmod +x build.sh
./build.sh

# Step 5: Report success
echo ""
echo "======================================================================"
echo "✅ SUCCESS: HTML documentation generated!"
echo ""
echo "Documentation location: $SCRIPT_DIR/$DEST_DIR/build/html/index.html"
echo ""
echo "Collection docs directory: $SCRIPT_DIR/$COLLECTION_DOCS_DIR"
echo ""
echo "To view the documentation:"
echo "  open $SCRIPT_DIR/$DEST_DIR/build/html/index.html"
echo ""
echo "Or start a simple HTTP server:"
echo "  cd $SCRIPT_DIR/$DEST_DIR/build/html"
echo "  python3 -m http.server 8000"
echo "  # Then open http://localhost:8000 in your browser"
echo ""
echo "Virtual environment: $VENV_DIR (can be reused for future runs)"
echo ""

