# rstyczynski.github.branch_push

Push current branch to remote repository.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `branch_push_dest_path` (string): Destination path to the git repository

### Output Variables

- `branch_push_git_push_result` (dict): Result of pushing to remote

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Push branch
      ansible.builtin.include_role:
        name: rstyczynski.github.branch_push
      vars:
        branch_push_dest_path: "./repo"
```

## License

MIT

## Author

rstyczynski
