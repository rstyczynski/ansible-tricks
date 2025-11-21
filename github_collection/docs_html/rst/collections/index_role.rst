:orphan:

.. meta::
  :antsibull-docs: 2.22.1

.. _list_of_role_plugins:

Index of all Roles
==================

rstyczynski.github
------------------

* :ansplugin:`rstyczynski.github.branch_checkout#role` -- Checks out or creates a new branch, with optional push to remote
* :ansplugin:`rstyczynski.github.branch_delete#role` -- Deletes branch both locally and remotely in idempotent manner
* :ansplugin:`rstyczynski.github.branch_pull#role` -- Pulls latest changes from remote for current branch
* :ansplugin:`rstyczynski.github.branch_push#role` -- Pushes current branch changes to remote repository
* :ansplugin:`rstyczynski.github.branch_switch#role` -- Switches to an existing local or remote branch
* :ansplugin:`rstyczynski.github.github_auth#role` -- Authenticates GitHub CLI using token from environment or .netrc
* :ansplugin:`rstyczynski.github.github_logout#role` -- Logs out from GitHub CLI and clears authentication state
* :ansplugin:`rstyczynski.github.github_precheck#role` -- Verifies system prerequisites including git installation and GitHub CLI authentication status
* :ansplugin:`rstyczynski.github.pr_comment#role` -- Adds comment to pull request for current branch
* :ansplugin:`rstyczynski.github.pr_create#role` -- Creates a new pull request using GitHub CLI with customizable title and body
* :ansplugin:`rstyczynski.github.pr_merge#role` -- Merges a pull request using specified method (merge, squash, or rebase)
* :ansplugin:`rstyczynski.github.pr_status_check#role` -- Checks pull request status including CI checks and review state
* :ansplugin:`rstyczynski.github.pr_status_check_pause#role` -- Waits for PR status checks to complete with configurable retries
* :ansplugin:`rstyczynski.github.repo_clone#role` -- Clones GitHub repository or updates existing clone with branch sync
* :ansplugin:`rstyczynski.github.repo_commit#role` -- Creates git commit with specified message if changes are staged
* :ansplugin:`rstyczynski.github.repo_file_add#role` -- Copies file into repository and stages it for commit
