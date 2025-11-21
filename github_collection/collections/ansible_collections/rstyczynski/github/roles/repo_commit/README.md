# rstyczynski.github.repo_commit

Commit changes to Git repository.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `repo_commit_dest_path` (string): Destination path to the git repository

### Optional Variables

- `repo_commit_commit_message` (string): Commit message (optional)
- `repo_commit_file_path` (string): File path for commit message fallback

### Output Variables

- `repo_commit_git_status` (dict): Git status information
- `repo_commit_final_commit_message` (string): Final commit message to use
- `repo_commit_git_commit_result` (dict): Result of committing changes

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Commit changes
      ansible.builtin.include_role:
        name: rstyczynski.github.repo_commit
      vars:
        repo_commit_dest_path: "./repo"
        repo_commit_commit_message: "Add new feature"
```

## License

MIT

## Author

rstyczynski
