# rstyczynski.github.pr_merge

Merge GitHub pull requests with status check validation.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `pr_merge_dest_path` (string): Destination path to the git repository

### Optional Variables

- `pr_merge_pr_merge_method` (string): Merge method: merge, squash, or rebase

### Output Variables

- `pr_merge_current_branch` (dict): Current branch name
- `pr_merge_pr_number` (dict): PR number for current branch
- `pr_merge_pr_state` (dict): PR state information
- `pr_merge_pr_info` (dict): Parsed PR state information
- `pr_merge_pr_status_checks_for_merge` (dict): PR status checks for merge
- `pr_merge_status_checks_for_merge` (list): Parsed status checks for merge
- `pr_merge_failed_checks_for_merge` (list): Failed status checks
- `pr_merge_pending_checks_for_merge` (list): Pending status checks
- `pr_merge_pr_merge_result` (dict): Result of merging PR

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Merge pull request
      ansible.builtin.include_role:
        name: rstyczynski.github.pr_merge
      vars:
        pr_merge_dest_path: "./repo"
        pr_merge_pr_merge_method: "squash"
```

## License

MIT

## Author

rstyczynski
