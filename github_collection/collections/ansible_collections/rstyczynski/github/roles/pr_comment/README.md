# rstyczynski.github.pr_comment

Add comments to GitHub pull requests.

## Requirements

- GitHub CLI (gh) installed and authenticated
- Git installed
- Repository access via ~/.netrc

## Role Variables

### Required Variables

- `pr_comment_dest_path` (string): Destination path to the git repository

### Optional Variables

- `pr_comment_pr_comment` (string): Comment text to add to PR

### Output Variables

- `pr_comment_current_branch` (dict): Current branch name
- `pr_comment_pr_number` (dict): PR number for current branch
- `pr_comment_last_pr_comment` (dict): Last comment on PR
- `pr_comment_pr_comment_result` (dict): Result of adding comment to PR

## Dependencies

None

## Example Playbook

```yaml
- hosts: localhost
  tasks:
    - name: Comment on PR
      ansible.builtin.include_role:
        name: rstyczynski.github.pr_comment
      vars:
        pr_comment_dest_path: "./repo"
        pr_comment_pr_comment: "LGTM! Ready to merge."
```

## License

MIT

## Author

rstyczynski
