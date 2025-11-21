#!/bin/bash
# verify_docs.sh - Verify ansible-doc works for all roles in rstyczynski.github Collection

echo "Verifying ansible-doc for all roles in rstyczynski.github Collection"
echo "======================================================================"
echo ""

ROLES="github_precheck github_auth github_logout repo_clone branch_checkout branch_switch branch_pull branch_push branch_delete repo_file_add repo_commit pr_create pr_status_check pr_status_check_pause pr_comment pr_merge"

FAILED=0
PASSED=0

for role in $ROLES; do
    echo -n "Checking rstyczynski.github.$role ... "
    if ansible-doc rstyczynski.github.$role > /dev/null 2>&1; then
        echo "✅ OK"
        PASSED=$((PASSED + 1))
    else
        echo "❌ FAILED"
        FAILED=$((FAILED + 1))
        echo "  Error details:"
        ansible-doc rstyczynski.github.$role 2>&1 | head -5 | sed 's/^/    /'
    fi
done

echo ""
echo "===================================================================="
echo "Results: $PASSED/16 roles documented successfully"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "✅ SUCCESS: All roles have valid documentation"
    exit 0
else
    echo "❌ FAILURE: $FAILED roles failed documentation check"
    exit 1
fi
