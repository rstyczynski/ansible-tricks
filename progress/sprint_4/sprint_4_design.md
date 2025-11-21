# Sprint 4 - Design

## GHC-6. GitHub Collection HTML documentation generation

Status: Proposed

### Requirement Summary

Generate HTML documentation site for the entire `rstyczynski.github` Ansible Collection using `antsibull-docs` tool. The documentation should include all 16 roles with their argument specifications, descriptions, and parameter details in a browsable Sphinx-based format. Provide a script (`generate_html_docs.sh`) that automates the process of initializing the Sphinx site, installing dependencies, and building the HTML documentation.

### Feasibility Analysis

**API Availability:**

✅ **antsibull-docs Tool**: Official Ansible tool for generating collection documentation
- Command: `antsibull-docs sphinx-init` - Initializes Sphinx documentation site
- Command: `antsibull-docs` - Available via pip install
- Documentation: https://docs.ansible.com/projects/ansible/latest/dev_guide/developing_collections_documenting.html
- **Status**: Available and well-documented

✅ **Collection Structure**: All prerequisites are in place
- All 16 roles have `meta/argument_specs.yml` files (Sprint 3 - GHC-4)
- Collection structure is complete in `github_collection/collections/ansible_collections/rstyczynski/github/`
- Collection metadata (`galaxy.yml`) is present
- **Status**: Ready for documentation generation

✅ **Script Exists**: `generate_html_docs.sh` already exists in `github_collection/` directory
- Script implements required functionality
- Uses `antsibull-docs sphinx-init` correctly
- Handles dependency installation
- Builds HTML documentation
- **Status**: Needs validation and potential enhancement for best practices compliance

**Technical Constraints:**

1. **Virtual Environment**: Must follow ANSIBLE_BEST_PRACTICES.md
   - Use `.venv` in project directory (not home directory)
   - Current script checks for virtual environment but doesn't create one automatically
   - Need to enhance script to create/use `.venv` in `github_collection/` directory

2. **Collection Path**: Script must work from `github_collection/` directory
   - Collection is located at `collections/ansible_collections/rstyczynski/github/`
   - `antsibull-docs sphinx-init` needs collection name (`rstyczynski.github`) and proper path context
   - Current script handles this correctly

3. **Python Dependencies**: Generated `requirements.txt` from `antsibull-docs` must be installed
   - Dependencies are managed by `antsibull-docs` tool
   - Need to ensure virtual environment is used for installation

**Risk Assessment:**

- **Risk 1: Virtual Environment Not Used**
  - **Description**: Script may install dependencies globally instead of in virtual environment
  - **Mitigation**: Enhance script to create/activate `.venv` in `github_collection/` directory before installing dependencies
  - **Severity**: Medium (violates ANSIBLE_BEST_PRACTICES.md)

- **Risk 2: Script Execution from Wrong Directory**
  - **Description**: Script may fail if executed from wrong directory
  - **Mitigation**: Script already uses `SCRIPT_DIR` to ensure correct directory context
  - **Severity**: Low (already handled)

- **Risk 3: Missing Prerequisites**
  - **Description**: `antsibull-docs` may not be installed
  - **Mitigation**: Script checks for `antsibull-docs` and provides installation instructions
  - **Severity**: Low (already handled)

- **Risk 4: Generated Documentation Incomplete**
  - **Description**: Generated HTML may not include all roles or argument specifications
  - **Mitigation**: Test script execution and verify generated documentation includes all 16 roles
  - **Severity**: Low (can be verified through testing)

### Design Overview

**Architecture:**

The solution consists of a single bash script (`generate_html_docs.sh`) that automates the complete documentation generation workflow:

1. **Validation Phase**: Check prerequisites (antsibull-docs installed, correct directory)
2. **Virtual Environment Phase**: Create/activate `.venv` in `github_collection/` directory
3. **Initialization Phase**: Use `antsibull-docs sphinx-init` to create Sphinx site
4. **Dependency Installation Phase**: Install Python dependencies from generated `requirements.txt`
5. **Build Phase**: Execute generated `build.sh` to create HTML documentation
6. **Verification Phase**: Report success and provide access instructions

**Key Components:**

1. **generate_html_docs.sh** (Enhanced)
   - Purpose: Automate HTML documentation generation for the collection
   - Location: `github_collection/generate_html_docs.sh`
   - Interface: Executable bash script, no arguments required
   - Dependencies: `antsibull-docs` (installed via pip), Python 3, bash
   - Enhancements:
     - Create `.venv` in `github_collection/` directory if not exists
     - Activate virtual environment before installing dependencies
     - Ensure virtual environment is used throughout script execution

2. **Generated Documentation Structure** (by antsibull-docs)
   - `docs_html/` - Root directory for generated documentation
   - `docs_html/build/html/` - Final HTML documentation
   - `docs_html/requirements.txt` - Python dependencies (generated)
   - `docs_html/build.sh` - Build script (generated)
   - Sphinx configuration files (generated)

**Data Flow:**

```
User executes generate_html_docs.sh
  ↓
Script validates prerequisites (antsibull-docs, directory)
  ↓
Script creates/activates .venv in github_collection/
  ↓
Script runs: antsibull-docs sphinx-init --use-current --dest-dir docs_html rstyczynski.github
  ↓
antsibull-docs reads collection from collections/ansible_collections/rstyczynski/github/
  ↓
antsibull-docs generates Sphinx site in docs_html/
  ↓
Script installs dependencies from docs_html/requirements.txt (in virtual environment)
  ↓
Script executes docs_html/build.sh
  ↓
Sphinx builds HTML documentation in docs_html/build/html/
  ↓
Script reports success and provides access instructions
```

### Technical Specification

**APIs Used:**

- **antsibull-docs sphinx-init**
  - Method: Command-line tool
  - Purpose: Initialize Sphinx documentation site for Ansible collection
  - Parameters:
    - `--use-current`: Use current collection version
    - `--dest-dir <dir>`: Destination directory for generated site
    - `<collection_name>`: Collection FQCN (rstyczynski.github)
  - Documentation: https://docs.ansible.com/projects/ansible/latest/dev_guide/developing_collections_documenting.html
  - Output: Sphinx site structure in destination directory

- **antsibull-docs** (tool installation)
  - Method: pip install
  - Purpose: Install documentation generation tool
  - Command: `pip install antsibull-docs`
  - Alternative: Install in virtual environment

**Data Structures:**

N/A - This is a script-based solution, no complex data structures required.

**Scripts/Tools:**

- **File**: `github_collection/generate_html_docs.sh`
  - **Purpose**: Automate HTML documentation generation
  - **Interface**: Executable bash script, no command-line arguments
  - **Dependencies**:
    - `antsibull-docs` (must be installed)
    - Python 3
    - bash shell
  - **Enhancements Required**:
    1. Create `.venv` in `github_collection/` directory if not exists
    2. Activate virtual environment before dependency installation
    3. Ensure all pip commands use virtual environment
    4. Handle case where virtual environment already exists

**Error Handling:**

- **antsibull-docs not installed**: Script checks and provides installation instructions, exits with error
- **Wrong directory**: Script uses `SCRIPT_DIR` to ensure correct context
- **Virtual environment creation fails**: Script should report error and exit
- **Sphinx initialization fails**: Script checks for `docs_html/` directory creation, exits with error if missing
- **requirements.txt missing**: Script checks for file existence, exits with error if missing
- **build.sh missing**: Script checks for file existence, exits with error if missing
- **Build process fails**: Script uses `set -e` to exit on any error

### Implementation Approach

**Step 1:** Review existing `generate_html_docs.sh` script
- Verify current implementation
- Identify areas needing enhancement for best practices compliance

**Step 2:** Enhance script for virtual environment handling
- Add logic to create `.venv` in `github_collection/` directory if not exists
- Add logic to activate virtual environment
- Ensure all pip commands use virtual environment
- Update virtual environment check to use project directory `.venv`

**Step 3:** Test script execution
- Execute script from `github_collection/` directory
- Verify virtual environment creation
- Verify Sphinx site initialization
- Verify dependency installation
- Verify HTML build process

**Step 4:** Validate generated documentation
- Verify `docs_html/build/html/index.html` exists
- Verify all 16 roles appear in documentation
- Verify role argument specifications are included
- Verify documentation is browsable

**Step 5:** Document usage and verify compliance
- Ensure script follows ANSIBLE_BEST_PRACTICES.md
- Document any deviations or special considerations
- Create test documentation

### Testing Strategy

**Functional Tests:**

1. **Test 1: Script Execution from Correct Directory**
   - Execute script from `github_collection/` directory
   - Verify script completes successfully
   - Verify `docs_html/build/html/index.html` is created

2. **Test 2: Virtual Environment Creation**
   - Execute script in fresh environment (no `.venv` exists)
   - Verify `.venv` is created in `github_collection/` directory
   - Verify virtual environment is activated
   - Verify dependencies are installed in virtual environment

3. **Test 3: Existing Virtual Environment**
   - Execute script when `.venv` already exists
   - Verify script uses existing virtual environment
   - Verify script completes successfully

4. **Test 4: Documentation Completeness**
   - Execute script and verify generated HTML
   - Verify all 16 roles appear in documentation
   - Verify role argument specifications are included
   - Verify role descriptions are present

5. **Test 5: Documentation Browsability**
   - Open `docs_html/build/html/index.html` in browser
   - Verify navigation works
   - Verify links are functional
   - Verify content is properly formatted

**Edge Cases:**

1. **Test 6: antsibull-docs Not Installed**
   - Remove `antsibull-docs` from system
   - Execute script
   - Verify script detects missing tool and provides installation instructions
   - Verify script exits with error

2. **Test 7: Script Execution from Wrong Directory**
   - Execute script from project root
   - Verify script handles directory context correctly (uses SCRIPT_DIR)
   - Verify script completes successfully

3. **Test 8: Existing docs_html Directory**
   - Create `docs_html/` directory manually
   - Execute script
   - Verify script removes existing directory and recreates it
   - Verify script completes successfully

**Success Criteria:**

- ✅ Script executes successfully from `github_collection/` directory
- ✅ Virtual environment (`.venv`) is created/used in `github_collection/` directory
- ✅ Sphinx site is initialized correctly
- ✅ Dependencies are installed in virtual environment
- ✅ HTML documentation is built successfully
- ✅ Generated documentation includes all 16 roles
- ✅ Role argument specifications are present in documentation
- ✅ Documentation is browsable and functional
- ✅ Script follows ANSIBLE_BEST_PRACTICES.md (virtual environment usage)

### Integration Notes

**Dependencies:**

- **Sprint 3 Deliverables**: Requires GHC-4 (argument_specs.yml files) and GHC-5 (ansible-doc documentation) - ✅ Complete
- **Collection Structure**: Requires complete collection structure - ✅ Complete
- **External Tool**: Requires `antsibull-docs` Python package

**Compatibility:**

- **Sprint 3 Integration**: Builds on existing argument specifications and documentation
- **Collection Structure**: Works with existing collection structure
- **Best Practices**: Aligns with ANSIBLE_BEST_PRACTICES.md (virtual environment usage)

**Reusability:**

- Script can be reused for future collection documentation updates
- Script follows standard Ansible documentation generation process
- Script can be adapted for other collections if needed

### Documentation Requirements

**User Documentation:**

- Script usage instructions
- Prerequisites (antsibull-docs installation)
- Virtual environment requirements
- Output location and access instructions
- Troubleshooting common issues

**Technical Documentation:**

- Script enhancement details
- Virtual environment handling approach
- Integration with antsibull-docs tool
- Generated documentation structure

### Design Decisions

**Decision 1: Enhance Existing Script vs. Create New**
- **Decision Made**: Enhance existing `generate_html_docs.sh` script
- **Rationale**: Script already exists and implements most required functionality. Enhancement is more efficient than recreation.
- **Alternatives Considered**: Create new script from scratch
- **Risk**: Low - Existing script provides good foundation

**Decision 2: Virtual Environment Location**
- **Decision Made**: Use `.venv` in `github_collection/` directory
- **Rationale**: Follows ANSIBLE_BEST_PRACTICES.md requirement to use `.venv` in project directory (not home directory)
- **Alternatives Considered**: Use system-wide Python, use home directory virtual environment
- **Risk**: Low - Standard practice, well-documented

**Decision 3: Virtual Environment Creation Strategy**
- **Decision Made**: Create `.venv` automatically if not exists, use existing if present
- **Rationale**: Provides best user experience - automatic setup with option to reuse existing environment
- **Alternatives Considered**: Require manual virtual environment creation, always recreate virtual environment
- **Risk**: Low - Standard practice

**Decision 4: Error Handling Approach**
- **Decision Made**: Use `set -e` for automatic error handling, add explicit checks for critical steps
- **Rationale**: Provides robust error handling without excessive complexity
- **Alternatives Considered**: Manual error handling for each step, no error handling
- **Risk**: Low - Standard bash practice

### Open Design Questions

**None** - All design aspects are clear and well-defined.

---

# Design Summary

## Overall Architecture

The solution enhances the existing `generate_html_docs.sh` script to fully comply with ANSIBLE_BEST_PRACTICES.md while maintaining all existing functionality. The script automates the complete workflow from Sphinx site initialization to HTML documentation generation, with proper virtual environment management.

## Shared Components

- **Virtual Environment**: `.venv` in `github_collection/` directory (shared with other Python tooling if needed)
- **Collection Structure**: Uses existing collection structure from previous sprints
- **antsibull-docs Tool**: Standard Ansible tool for collection documentation

## Design Risks

- **Low Risk**: Script enhancement is straightforward
- **Low Risk**: Virtual environment handling is well-understood
- **Low Risk**: antsibull-docs is official tool with good documentation
- **Low Risk**: All prerequisites are in place

## Resource Requirements

- **Tools**: `antsibull-docs` (Python package), Python 3, bash
- **Libraries**: Python dependencies (managed by antsibull-docs generated requirements.txt)
- **External Services**: None required
- **Disk Space**: ~50-100MB for generated documentation (estimated)

## Design Approval Status

**Awaiting Review** - Design is complete and ready for Product Owner approval.

