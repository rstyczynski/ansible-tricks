# rstyczynski.github.pr_status_check

Check GitHub pull request status checks.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `pr_status_check_gh_version` (dict): GitHub CLI version check result
- `pr_status_check_gh_auth_status` (dict): GitHub CLI authentication status
- `pr_status_check_dest_path` (string): Destination path to the git repository

### Output Variables

- `pr_status_check_current_branch` (dict): Current branch name
- `pr_status_check_pr_number` (dict): PR number for current branch
- `pr_status_check_pr_status_checks` (dict): PR status checks information
- `pr_status_check_status_checks` (list): Parsed status checks
- `pr_status_check_total_checks` (int): Total number of status checks
- `pr_status_check_failed_checks` (list): Failed status checks
- `pr_status_check_pending_checks` (list): Pending status checks
- `pr_status_check_passed_checks` (list): Passed status checks
- `pr_status_check_has_pending_checks` (bool): Whether there are pending checks

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Check PR status
      ansible.builtin.include_role:
        name: rstyczynski.github.pr_status_check
      vars:
        pr_status_check_gh_version: "{{ precheck_gh_version }}"
        pr_status_check_gh_auth_status: "{{ precheck_gh_auth_status }}"
        pr_status_check_dest_path: "./repo"
```

## License

MIT

## Author

rstyczynski
