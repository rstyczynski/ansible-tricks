# Sprint 4 - Functional Tests

## Test Environment Setup

### Prerequisites

- Python 3.6+ installed
- `antsibull-docs` installed (can be installed globally or in virtual environment)
- Bash shell
- Access to `github_collection/` directory
- Collection structure complete with all 16 roles

### Installation of antsibull-docs

If `antsibull-docs` is not installed, install it first:

```bash
# Option 1: Install globally
pip install antsibull-docs

# Option 2: Install in a virtual environment (recommended)
python3 -m venv venv
source venv/bin/activate
pip install antsibull-docs
```

## GHC-6 Tests

### Test 1: Script Execution from Correct Directory

**Purpose:** Verify script executes successfully from `github_collection/` directory and generates HTML documentation.

**Expected Outcome:** Script completes successfully, creates `docs_html/build/html/index.html`, and all 16 roles appear in documentation.

**Test Sequence:**

```bash
# Step 1: Navigate to github_collection directory
cd /Users/rstyczynski/projects/ansible-tricks/github_collection

# Step 2: Verify script exists and is executable
ls -la generate_html_docs.sh
chmod +x generate_html_docs.sh

# Step 3: Execute the script
./generate_html_docs.sh

# Expected output should show:
# - Collection name
# - Step 1: Initializing Sphinx documentation site
# - Step 2: Setting up virtual environment
# - Step 3: Installing Python requirements
# - Step 4: Building HTML documentation
# - SUCCESS message with documentation location

# Step 4: Verify documentation was created
ls -la docs_html/build/html/index.html

# Step 5: Verify virtual environment was created
ls -la .venv

# Verification:
# - docs_html/build/html/index.html should exist
# - .venv directory should exist in github_collection/
# - Script should complete without errors
```

**Status:** PENDING

**Notes:** Test requires `antsibull-docs` to be installed.

---

### Test 2: Virtual Environment Creation

**Purpose:** Verify script creates `.venv` in `github_collection/` directory when it doesn't exist.

**Expected Outcome:** Script creates `.venv` directory, activates it, and uses it for dependency installation.

**Test Sequence:**

```bash
# Step 1: Navigate to github_collection directory
cd /Users/rstyczynski/projects/ansible-tricks/github_collection

# Step 2: Remove existing virtual environment if it exists
rm -rf .venv

# Step 3: Execute the script
./generate_html_docs.sh

# Step 4: Verify virtual environment was created
ls -la .venv

# Step 5: Verify virtual environment is active during script execution
# (Check script output for "Virtual environment activated: ...")

# Step 6: Verify pip was used from virtual environment
# (Check that dependencies were installed in .venv, not globally)

# Verification:
# - .venv directory should exist in github_collection/
# - Script output should show "Virtual environment activated"
# - Dependencies should be installed in .venv, not globally
```

**Status:** PENDING

**Notes:** This test verifies ANSIBLE_BEST_PRACTICES.md compliance.

---

### Test 3: Existing Virtual Environment Reuse

**Purpose:** Verify script uses existing `.venv` when it already exists.

**Expected Outcome:** Script detects existing virtual environment, activates it, and uses it without recreating.

**Test Sequence:**

```bash
# Step 1: Navigate to github_collection directory
cd /Users/rstyczynski/projects/ansible-tricks/github_collection

# Step 2: Ensure virtual environment exists (from previous test)
ls -la .venv

# Step 3: Note the modification time of .venv
stat -f "%Sm" .venv

# Step 4: Execute the script
./generate_html_docs.sh

# Step 5: Verify virtual environment modification time didn't change significantly
# (Script should not recreate .venv, just activate it)

# Verification:
# - Script should use existing .venv
# - Script should not recreate .venv
# - Script should complete successfully
```

**Status:** PENDING

**Notes:** This test verifies script doesn't unnecessarily recreate virtual environment.

---

### Test 4: Documentation Completeness

**Purpose:** Verify generated HTML documentation includes all 16 roles with their argument specifications.

**Expected Outcome:** Generated documentation includes all 16 roles, their descriptions, and argument specifications.

**Test Sequence:**

```bash
# Step 1: Navigate to github_collection directory
cd /Users/rstyczynski/projects/ansible-tricks/github_collection

# Step 2: Execute the script (if not already done)
./generate_html_docs.sh

# Step 3: Verify documentation file exists
ls -la docs_html/build/html/index.html

# Step 4: Check documentation content for all 16 roles
# Expected roles:
# - branch_checkout
# - branch_delete
# - branch_pull
# - branch_push
# - branch_switch
# - github_auth
# - github_logout
# - github_precheck
# - pr_comment
# - pr_create
# - pr_merge
# - pr_status_check
# - pr_status_check_pause
# - repo_clone
# - repo_commit
# - repo_file_add

# Step 5: Open documentation in browser (optional)
open docs_html/build/html/index.html

# Step 6: Verify role argument specifications are present
# (Check that roles show their input/output parameters)

# Verification:
# - All 16 roles should appear in documentation
# - Each role should have its description
# - Each role should show its argument specifications
# - Documentation should be properly formatted and browsable
```

**Status:** PENDING

**Notes:** Manual verification in browser recommended to check formatting and navigation.

---

### Test 5: Documentation Browsability

**Purpose:** Verify generated HTML documentation is browsable and functional.

**Expected Outcome:** Documentation can be opened in browser, navigation works, links are functional, content is properly formatted.

**Test Sequence:**

```bash
# Step 1: Navigate to github_collection directory
cd /Users/rstyczynski/projects/ansible-tricks/github_collection

# Step 2: Start a simple HTTP server to serve documentation
cd docs_html/build/html
python3 -m http.server 8000

# Step 3: Open browser and navigate to http://localhost:8000
# (Manual step - open browser)

# Step 4: Verify documentation loads
# - Home page should load
# - Navigation menu should be visible
# - Links should work

# Step 5: Navigate to a role page
# - Click on a role name
# - Verify role page loads
# - Verify argument specifications are visible
# - Verify descriptions are present

# Step 6: Test navigation
# - Use back/forward buttons
# - Click on different roles
# - Verify all links work

# Verification:
# - Documentation should load in browser
# - Navigation should work
# - All links should be functional
# - Content should be properly formatted
# - Role pages should show complete information
```

**Status:** PENDING

**Notes:** This is a manual test requiring browser interaction. Stop HTTP server with Ctrl+C after testing.

---

### Test 6: antsibull-docs Not Installed Error Handling

**Purpose:** Verify script handles missing `antsibull-docs` gracefully.

**Expected Outcome:** Script detects missing tool, provides installation instructions, and exits with error.

**Test Sequence:**

```bash
# Step 1: Navigate to github_collection directory
cd /Users/rstyczynski/projects/ansible-tricks/github_collection

# Step 2: Temporarily rename antsibull-docs (if installed globally)
# Note: This test may not work if antsibull-docs is in PATH
# Alternative: Test on a system without antsibull-docs

# Step 3: Execute the script
./generate_html_docs.sh

# Expected output:
# - ERROR message about antsibull-docs not being installed
# - Installation instructions
# - Script exits with error code 1

# Verification:
# - Script should detect missing tool
# - Script should provide helpful error message
# - Script should exit with non-zero exit code
```

**Status:** PENDING

**Notes:** This test may require a clean environment without antsibull-docs installed.

---

### Test 7: Script Execution from Wrong Directory

**Purpose:** Verify script handles execution from wrong directory correctly.

**Expected Outcome:** Script uses `SCRIPT_DIR` to ensure correct directory context and completes successfully.

**Test Sequence:**

```bash
# Step 1: Navigate to project root (not github_collection/)
cd /Users/rstyczynski/projects/ansible-tricks

# Step 2: Execute script with full path
./github_collection/generate_html_docs.sh

# Step 3: Verify script changes to correct directory
# (Check script output - it should work from any directory)

# Step 4: Verify documentation is created in correct location
ls -la github_collection/docs_html/build/html/index.html

# Verification:
# - Script should execute successfully from any directory
# - Documentation should be created in github_collection/docs_html/
# - Virtual environment should be created in github_collection/.venv
```

**Status:** PENDING

**Notes:** This test verifies script robustness and directory handling.

---

### Test 8: Existing docs_html Directory Handling

**Purpose:** Verify script handles existing `docs_html` directory correctly.

**Expected Outcome:** Script removes existing directory and recreates it.

**Test Sequence:**

```bash
# Step 1: Navigate to github_collection directory
cd /Users/rstyczynski/projects/ansible-tricks/github_collection

# Step 2: Create a test docs_html directory
mkdir -p docs_html/test_file
echo "test" > docs_html/test_file/test.txt

# Step 3: Execute the script
./generate_html_docs.sh

# Step 4: Verify old directory was removed and new one created
ls -la docs_html/
# test_file should not exist

# Step 5: Verify new documentation was created
ls -la docs_html/build/html/index.html

# Verification:
# - Old docs_html directory should be removed
# - New docs_html directory should be created
# - Documentation should be generated successfully
```

**Status:** PENDING

**Notes:** This test verifies script handles cleanup correctly.

---

## Test Summary

| Backlog Item | Total Tests | Passed | Failed | Status |
|--------------|-------------|--------|--------|--------|
| GHC-6        | 8           | 0      | 0      | PENDING |

## Overall Test Results

**Total Tests:** 8
**Passed:** 0
**Failed:** 0
**Pending:** 8
**Success Rate:** N/A (tests not yet executed)

## Test Execution Notes

**Prerequisites for Execution:**
- `antsibull-docs` must be installed (can be installed globally or in virtual environment)
- Python 3.6+ required
- Collection structure must be complete

**Execution Order:**
1. Test 1 should be executed first (basic functionality)
2. Test 2 and 3 can be executed together (virtual environment tests)
3. Test 4 and 5 require Test 1 to pass (documentation verification)
4. Test 6 requires special setup (missing tool)
5. Test 7 and 8 can be executed independently

**Known Limitations:**
- Test 6 may not be executable if antsibull-docs is always in PATH
- Test 5 requires manual browser interaction
- Some tests require previous tests to have passed

**Recommendations:**
- Execute tests in order for best results
- Verify all tests pass before marking implementation complete
- Document any test failures and resolutions

