#!/bin/bash
# generate_html_docs.sh - Generate HTML documentation for rstyczynski.github Collection
# Uses antsibull-docs as documented in:
# https://docs.ansible.com/projects/ansible/latest/dev_guide/developing_collections_documenting.html

set -e

COLLECTION_NAME="rstyczynski.github"
# Build directory for Sphinx build system (construction directory)
BUILD_DIR="docs_html"
# Collection's docs directory (only final HTML product goes here)
COLLECTION_DOCS_DIR="collections/ansible_collections/rstyczynski/github/docs"
COLLECTION_HTML_DIR="${COLLECTION_DOCS_DIR}/html"
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

# Remove existing build directory if it exists
if [ -d "$BUILD_DIR" ]; then
    echo "Removing existing $BUILD_DIR directory..."
    rm -rf "$BUILD_DIR"
fi

# Create build directory (antsibull-docs requires it to exist)
mkdir -p "$BUILD_DIR"

# Step 1: Initialize the Sphinx documentation site
echo "Step 1: Initializing Sphinx documentation site..."
antsibull-docs sphinx-init --use-current --dest-dir "$BUILD_DIR" "$COLLECTION_NAME"

if [ ! -d "$BUILD_DIR" ]; then
    echo "❌ ERROR: Failed to create $BUILD_DIR directory"
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
cd "$BUILD_DIR"

if [ ! -f "requirements.txt" ]; then
    echo "❌ ERROR: requirements.txt not found in $BUILD_DIR"
    exit 1
fi

pip install -q -r requirements.txt

# Step 4: Build the documentation
echo ""
echo "Step 4: Building HTML documentation..."
if [ ! -f "build.sh" ]; then
    echo "❌ ERROR: build.sh not found in $BUILD_DIR"
    exit 1
fi

chmod +x build.sh
./build.sh

# Step 5: Copy HTML output to collection's docs directory
echo ""
echo "Step 5: Copying HTML documentation to collection's docs/ directory..."
cd "$SCRIPT_DIR"

# Remove existing HTML in collection docs directory
if [ -d "$COLLECTION_HTML_DIR" ]; then
    echo "Removing existing HTML documentation from collection..."
    rm -rf "$COLLECTION_HTML_DIR"
fi

# Create collection docs directory if it doesn't exist
mkdir -p "$COLLECTION_DOCS_DIR"

# Copy only the HTML output (not build artifacts)
echo "Copying HTML files to $COLLECTION_HTML_DIR..."
cp -r "$BUILD_DIR/build/html" "$COLLECTION_HTML_DIR"

# Step 6: Report success
echo ""
echo "======================================================================"
echo "✅ SUCCESS: HTML documentation generated!"
echo ""
echo "Build directory (construction): $SCRIPT_DIR/$BUILD_DIR"
echo "Collection docs directory: $SCRIPT_DIR/$COLLECTION_DOCS_DIR"
echo "HTML documentation location: $SCRIPT_DIR/$COLLECTION_HTML_DIR/index.html"
echo ""
echo "To view the documentation:"
echo "  open $SCRIPT_DIR/$COLLECTION_HTML_DIR/index.html"
echo ""
echo "Or start a simple HTTP server:"
echo "  cd $SCRIPT_DIR/$COLLECTION_HTML_DIR"
echo "  python3 -m http.server 8000"
echo "  # Then open http://localhost:8000 in your browser"
echo ""
echo "Virtual environment: $VENV_DIR (can be reused for future runs)"
echo ""

