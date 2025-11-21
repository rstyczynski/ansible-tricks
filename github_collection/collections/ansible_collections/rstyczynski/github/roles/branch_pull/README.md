# rstyczynski.github.branch_pull

Pull latest changes from remote branch with fast-forward only strategy.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `branch_pull_dest_path` (string): Destination path to the git repository

### Output Variables

- `branch_pull_current_branch_for_pull` (dict): Current branch name
- `branch_pull_remote_tracking` (dict): Remote tracking branch information
- `branch_pull_git_fetch_result` (dict): Result of fetching from remote
- `branch_pull_behind_check` (dict): Result of checking if local is behind remote
- `branch_pull_git_pull_result` (dict): Result of pulling from remote

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Pull branch changes
      ansible.builtin.include_role:
        name: rstyczynski.github.branch_pull
      vars:
        branch_pull_dest_path: "./repo"
```

## License

MIT

## Author

rstyczynski
