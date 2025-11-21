# rstyczynski.github.repo_clone

Clone and manage GitHub repositories with proper branch handling.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `repo_clone_repo_url` (string): Repository URL to clone
- `repo_clone_dest_path` (string): Destination path for the repository
- `repo_clone_base_branch` (string): Base branch name
- `repo_clone_new_branch` (string): New branch name

### Output Variables

- `repo_clone_repo_exists` (dict): Result of checking if repository exists
- `repo_clone_git_result` (dict): Result of git clone/update operation
- `repo_clone_current_branch` (dict): Current active branch name
- `repo_clone_remote_branch_check` (dict): Result of checking if branch is pushed

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Clone repository
      ansible.builtin.include_role:
        name: rstyczynski.github.repo_clone
      vars:
        repo_clone_repo_url: "https://github.com/user/repo.git"
        repo_clone_dest_path: "./repo"
        repo_clone_base_branch: "main"
        repo_clone_new_branch: "feature"
```

## License

MIT

## Author

rstyczynski
