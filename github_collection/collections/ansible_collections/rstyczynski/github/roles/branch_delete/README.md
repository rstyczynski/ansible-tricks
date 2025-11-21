# rstyczynski.github.branch_delete

Delete Git branches locally and remotely with safety checks.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `branch_delete_dest_path` (string): Destination path to the git repository
- `branch_delete_base_branch` (string): Base branch name (protected branch)

### Optional Variables

- `branch_delete_delete_branch` (string): Branch name to delete (optional)
- `branch_delete_new_branch` (string): New branch name (fallback if delete_branch not set)

### Output Variables

- `branch_delete_current_branch` (dict): Current branch name
- `branch_delete_branch_to_delete` (string): Branch name to delete
- `branch_delete_current_branch_check` (dict): Current branch after setting branch_to_delete
- `branch_delete_checkout_base_result` (dict): Result of checking out base branch
- `branch_delete_local_branch_check` (dict): Result of checking if local branch exists
- `branch_delete_delete_local_result` (dict): Result of deleting local branch
- `branch_delete_force_delete_local_result` (dict): Result of force deleting local branch
- `branch_delete_remote_branch_check` (dict): Result of checking if remote branch exists
- `branch_delete_delete_remote_result` (dict): Result of deleting remote branch

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Delete branch
      ansible.builtin.include_role:
        name: rstyczynski.github.branch_delete
      vars:
        branch_delete_dest_path: "./repo"
        branch_delete_delete_branch: "feature/old-feature"
        branch_delete_base_branch: "main"
```

## License

MIT

## Author

rstyczynski
