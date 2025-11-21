# rstyczynski.github.repo_file_add

Add files to Git repository staging area.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `repo_file_add_dest_path` (string): Destination path to the git repository

### Optional Variables

- `repo_file_add_file_source` (string): Source file path to copy (optional)
- `repo_file_add_file_path` (string): File path in repository

### Output Variables

- `repo_file_add_file_path` (string): File path in repository (set from file_source)
- `repo_file_add_copy_result` (dict): Result of copying file
- `repo_file_add_file_stat` (dict): File stat information
- `repo_file_add_file_git_status` (dict): Git status of file
- `repo_file_add_git_add_result` (dict): Result of adding file to git

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Add file to repository
      ansible.builtin.include_role:
        name: rstyczynski.github.repo_file_add
      vars:
        repo_file_add_dest_path: "./repo"
        repo_file_add_file_source: "./local/file.txt"
        repo_file_add_file_path: "file.txt"
```

## License

MIT

## Author

rstyczynski
