# Sprint 5 - Functional Tests

## Test Environment Setup

### Prerequisites

- Ansible Core 2.11+ installed
- Collection available at: `github_collection/collections/ansible_collections/rstyczynski/github/`
- Working directory: `/Users/rstyczynski/projects/ansible-tricks`
- Shell: bash or zsh

### Environment Variables

```bash
COLLECTION_PATH="/Users/rstyczynski/projects/ansible-tricks/github_collection/collections/ansible_collections/rstyczynski/github"
```

---

## GHC-7 Tests: Argument Specification at Meta Directory

### Test 1: Verify meta/argument_specs.yml Files Exist

**Purpose:** Confirm all 16 roles have meta/argument_specs.yml files

**Expected Outcome:** All 16 roles should have the file

**Test Sequence:**

```bash
cd /Users/rstyczynski/projects/ansible-tricks

# Count roles with meta/argument_specs.yml
find github_collection/collections/ansible_collections/rstyczynski/github/roles/*/meta/argument_specs.yml | wc -l

# Expected output: 16

# List all roles with meta files
find github_collection/collections/ansible_collections/rstyczynski/github/roles/*/meta/argument_specs.yml

# Expected output:
# List of 16 files, one for each role
```

**Status:** PASS

**Notes:** All 16 roles have meta/argument_specs.yml files present.

---

### Test 2: Verify Validation Tasks Use Meta Directory

**Purpose:** Confirm validation tasks load specifications from meta/argument_specs.yml

**Expected Outcome:** 15 roles should have validation tasks using the file lookup pattern

**Test Sequence:**

```bash
cd /Users/rstyczynski/projects/ansible-tricks

# Check for correct pattern in validation tasks
grep -r "lookup('file', role_path + '/meta/argument_specs.yml')" \
  github_collection/collections/ansible_collections/rstyczynski/github/roles/*/tasks/main.yml | wc -l

# Expected output: 15

# Verify github_precheck has no validation (correct for role with no parameters)
grep -c "validate_argument_spec" \
  github_collection/collections/ansible_collections/rstyczynski/github/roles/github_precheck/tasks/main.yml || echo "0"

# Expected output: 0 (no validation task, which is correct)
```

**Status:** PASS

**Notes:** All 15 roles with parameters use the correct meta directory pattern. github_precheck correctly has no validation task.

---

### Test 3: Verify No Inline Argument Specifications

**Purpose:** Ensure argument specifications are not hardcoded in tasks/main.yml files

**Expected Outcome:** No inline argument specifications found (all use meta files)

**Test Sequence:**

```bash
cd /Users/rstyczynski/projects/ansible-tricks

# Search for inline argument specs (old pattern that should NOT exist)
# This searches for argument_spec with direct YAML definitions
grep -r "argument_spec:" \
  github_collection/collections/ansible_collections/rstyczynski/github/roles/*/tasks/main.yml \
  | grep -v "lookup('file'" | wc -l

# Expected output: 0 (no inline specs found)

# Verification: All argument_spec should reference meta files
grep -r "argument_spec:" \
  github_collection/collections/ansible_collections/rstyczynski/github/roles/*/tasks/main.yml \
  | grep "lookup('file'" | wc -l

# Expected output: 15 (all use meta file lookup)
```

**Status:** PASS

**Notes:** No inline argument specifications found. All validation tasks properly reference meta/argument_specs.yml.

---

### Test 4: Verify ansible-doc Works for All Roles

**Purpose:** Confirm ansible-doc can read specifications from meta files

**Expected Outcome:** Documentation generates successfully for all 16 roles

**Test Sequence:**

```bash
cd /Users/rstyczynski/projects/ansible-tricks/github_collection

# Set collection path
export ANSIBLE_COLLECTIONS_PATH=$(pwd)/collections

# Test ansible-doc for each role
for role in branch_checkout branch_delete branch_pull branch_push branch_switch \
            github_auth github_logout github_precheck pr_comment pr_create \
            pr_merge pr_status_check pr_status_check_pause repo_clone \
            repo_commit repo_file_add; do
  echo "Testing: $role"
  ansible-doc rstyczynski.github.$role > /dev/null 2>&1 && echo "  ✓ PASS" || echo "  ✗ FAIL"
done

# Expected output:
# Testing: branch_checkout
#   ✓ PASS
# Testing: branch_delete
#   ✓ PASS
# [... etc for all 16 roles ...]
```

**Status:** PASS

**Notes:** All 16 roles generate documentation successfully via ansible-doc.

---

### Test 5: Verify Consistent Pattern Across All Roles

**Purpose:** Ensure all roles use the same validation pattern consistently

**Expected Outcome:** All validation tasks follow identical pattern

**Test Sequence:**

```bash
cd /Users/rstyczynski/projects/ansible-tricks

# Extract validation task patterns from all roles
for role in branch_checkout branch_delete branch_pull branch_push branch_switch \
            github_auth github_logout pr_comment pr_create pr_merge \
            pr_status_check pr_status_check_pause repo_clone repo_commit repo_file_add; do
  echo "=== $role ==="
  grep -A2 "Validate arguments" \
    "github_collection/collections/ansible_collections/rstyczynski/github/roles/${role}/tasks/main.yml"
done

# Expected output:
# All roles should show:
# - name: "[Role]: Validate arguments"
#   ansible.builtin.validate_argument_spec:
#     argument_spec: "{{ (lookup('file', role_path + '/meta/argument_specs.yml') | from_yaml).argument_specs.main.options }}"
```

**Status:** PASS

**Notes:** All 15 roles with validation use identical pattern. Only role names differ.

---

### Test 6: Verify Meta Files Are Valid YAML

**Purpose:** Ensure all meta/argument_specs.yml files are syntactically correct

**Expected Outcome:** All files parse as valid YAML

**Test Sequence:**

```bash
cd /Users/rstyczynski/projects/ansible-tricks

# Test YAML syntax for all meta files
for role_meta in github_collection/collections/ansible_collections/rstyczynski/github/roles/*/meta/argument_specs.yml; do
  role=$(basename $(dirname $(dirname "$role_meta")))
  echo -n "Testing $role: "
  python3 -c "import yaml; yaml.safe_load(open('$role_meta'))" 2>/dev/null && echo "✓ Valid YAML" || echo "✗ Invalid YAML"
done

# Expected output:
# Testing branch_checkout: ✓ Valid YAML
# Testing branch_delete: ✓ Valid YAML
# [... etc for all 16 roles ...]
```

**Status:** PASS

**Notes:** All meta/argument_specs.yml files are valid YAML.

---

### Test 7: Verify Meta Files Have Required Structure

**Purpose:** Confirm meta files contain argument_specs.main.options structure

**Expected Outcome:** All meta files have correct structure

**Test Sequence:**

```bash
cd /Users/rstyczynski/projects/ansible-tricks

# Check for required structure in meta files
for role_meta in github_collection/collections/ansible_collections/rstyczynski/github/roles/*/meta/argument_specs.yml; do
  role=$(basename $(dirname $(dirname "$role_meta")))
  echo -n "Testing $role: "
  grep -q "argument_specs:" "$role_meta" && \
  grep -q "main:" "$role_meta" && \
  echo "✓ Has required structure" || echo "✗ Missing structure"
done

# Expected output:
# Testing branch_checkout: ✓ Has required structure
# Testing branch_delete: ✓ Has required structure
# [... etc for all 16 roles ...]
```

**Status:** PASS

**Notes:** All meta files contain the required argument_specs.main structure.

---

### Test 8: Verify INPUT/OUTPUT Tables Preserved in Tasks

**Purpose:** Confirm roles still have human-readable documentation tables

**Expected Outcome:** All roles have INPUT and OUTPUT variable tables

**Test Sequence:**

```bash
cd /Users/rstyczynski/projects/ansible-tricks

# Check for INPUT/OUTPUT tables in all roles
for role in branch_checkout branch_delete branch_pull branch_push branch_switch \
            github_auth github_logout github_precheck pr_comment pr_create \
            pr_merge pr_status_check pr_status_check_pause repo_clone \
            repo_commit repo_file_add; do
  echo -n "Testing $role: "
  tasks_file="github_collection/collections/ansible_collections/rstyczynski/github/roles/${role}/tasks/main.yml"
  grep -q "INPUT VARIABLES TABLE" "$tasks_file" && \
  grep -q "OUTPUT VARIABLES TABLE" "$tasks_file" && \
  echo "✓ Has tables" || echo "✗ Missing tables"
done

# Expected output:
# Testing branch_checkout: ✓ Has tables
# Testing branch_delete: ✓ Has tables
# [... etc for all 16 roles ...]
```

**Status:** PASS

**Notes:** All roles preserve human-readable INPUT/OUTPUT variable documentation tables.

---

## Test Summary

| Test | Description | Status | Notes |
|------|-------------|--------|-------|
| Test 1 | meta/argument_specs.yml files exist | PASS | 16/16 roles |
| Test 2 | Validation tasks use meta directory | PASS | 15/15 roles (precheck N/A) |
| Test 3 | No inline argument specifications | PASS | 0 inline specs found |
| Test 4 | ansible-doc works for all roles | PASS | 16/16 roles |
| Test 5 | Consistent pattern across roles | PASS | Pattern verified |
| Test 6 | Meta files are valid YAML | PASS | 16/16 files |
| Test 7 | Meta files have required structure | PASS | 16/16 files |
| Test 8 | INPUT/OUTPUT tables preserved | PASS | 16/16 roles |

## Overall Test Results

**Total Tests:** 8
**Passed:** 8
**Failed:** 0
**Success Rate:** 100%

## Test Execution Notes

### Observations

1. All roles correctly implement GHC-7 requirement
2. Pattern is consistent across all 15 roles with validation
3. github_precheck correctly has no validation (no parameters)
4. Meta files are well-formed and valid
5. Human-readable documentation tables preserved alongside meta specs
6. ansible-doc integration works perfectly

### Issues Encountered

None - All tests passed on first execution.

### Recommendations

1. ✅ Current implementation meets all GHC-7 requirements
2. ✅ Pattern is consistent and maintainable
3. ✅ Documentation generation works correctly
4. ✅ No changes needed

### Compliance Verification

**GHC-7 Requirement:** "Make sure that all roles use argument specification at meta directory. Do not keep argument specification for rules inline. Use `ansible.builtin.validate_argument_spec` module with spec taken from meta directory."

**Compliance Status:** ✅ **FULLY COMPLIANT**

- ✅ All roles use argument specifications from meta directory
- ✅ No inline argument specifications found
- ✅ validate_argument_spec module uses spec from meta directory
- ✅ Pattern example from BACKLOG.md is correctly implemented

---

## Conclusion

All functional tests pass successfully. GHC-7 implementation is complete and verified. The collection is ready for production use with all roles properly implementing argument specification at the meta directory level.
