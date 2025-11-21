# rstyczynski.github.branch_checkout

Checkout or create Git branches with remote synchronization support.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `branch_checkout_new_branch` (string): Name of the branch to checkout or create
- `branch_checkout_dest_path` (string): Destination path to the git repository
- `branch_checkout_base_branch` (string): Base branch name to checkout before creating

### Optional Variables

- `branch_checkout_push_new_branch` (bool): Whether to push new branch to remote

### Output Variables

- `branch_checkout_branch_check` (dict): Result of checking if branch exists locally
- `branch_checkout_remote_branch_check` (dict): Result of checking if branch exists remotely
- `branch_checkout_current_branch_before_checkout` (dict): Current branch before checkout
- `branch_checkout_checkout_result` (dict): Result of checking out existing branch
- `branch_checkout_current_branch_before_base` (dict): Current branch before base checkout
- `branch_checkout_create_branch_result` (dict): Result of creating new branch
- `branch_checkout_current_branch_before_switch` (dict): Current branch before switching
- `branch_checkout_push_branch_result` (dict): Result of pushing branch to remote
- `branch_checkout_current_branch` (dict): Current branch after checkout

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Checkout branch
      ansible.builtin.include_role:
        name: rstyczynski.github.branch_checkout
      vars:
        branch_checkout_new_branch: "feature/new-feature"
        branch_checkout_dest_path: "./repo"
        branch_checkout_base_branch: "main"
        branch_checkout_push_new_branch: true
```

## License

MIT

## Author

rstyczynski
