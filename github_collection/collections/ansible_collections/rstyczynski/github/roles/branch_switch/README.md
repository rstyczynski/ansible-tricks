# rstyczynski.github.branch_switch

Switch to a different Git branch.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `branch_switch_dest_path` (string): Destination path to the git repository
- `branch_switch_switch_to_branch` (string): Branch name to switch to

### Output Variables

- `branch_switch_current_branch_before_switch` (dict): Current branch before switching
- `branch_switch_checkout_result` (dict): Result of checking out target branch

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Switch branch
      ansible.builtin.include_role:
        name: rstyczynski.github.branch_switch
      vars:
        branch_switch_dest_path: "./repo"
        branch_switch_switch_to_branch: "main"
```

## License

MIT

## Author

rstyczynski
