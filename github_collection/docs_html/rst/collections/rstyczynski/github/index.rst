.. meta::
  :antsibull-docs: 2.22.1


.. _plugins_in_rstyczynski.github:

Rstyczynski.Github
==================

Collection version 1.0.0

.. contents::
   :local:
   :depth: 1

Description
-----------

Ansible Collection for GitHub operations using gh CLI

**Author:**

* rstyczynski <rstyczynski@users.noreply.github.com>

**Supported ansible-core versions:**

* 2.9 or newer

.. ansible-links::

  - title: "Issue Tracker"
    url: "https://github.com/rstyczynski/ansible-tricks/issues"
    external: true
  - title: "Repository (Sources)"
    url: "https://github.com/rstyczynski/ansible-tricks"
    external: true




.. toctree::
    :maxdepth: 1

.. _plugin_index_for_rstyczynski.github:

Plugin Index
------------

There are no plugins in the rstyczynski.github collection with automatically generated documentation.


.. _role_plugins_in_rstyczynski.github:

Role Index
----------

These are the roles in the rstyczynski.github collection:

* :ansplugin:`branch_checkout role <rstyczynski.github.branch_checkout#role>` -- Checks out or creates a new branch, with optional push to remote
* :ansplugin:`branch_delete role <rstyczynski.github.branch_delete#role>` -- Deletes branch both locally and remotely in idempotent manner
* :ansplugin:`branch_pull role <rstyczynski.github.branch_pull#role>` -- Pulls latest changes from remote for current branch
* :ansplugin:`branch_push role <rstyczynski.github.branch_push#role>` -- Pushes current branch changes to remote repository
* :ansplugin:`branch_switch role <rstyczynski.github.branch_switch#role>` -- Switches to an existing local or remote branch
* :ansplugin:`github_auth role <rstyczynski.github.github_auth#role>` -- Authenticates GitHub CLI using token from environment or .netrc
* :ansplugin:`github_logout role <rstyczynski.github.github_logout#role>` -- Logs out from GitHub CLI and clears authentication state
* :ansplugin:`github_precheck role <rstyczynski.github.github_precheck#role>` -- Verifies system prerequisites including git installation and GitHub CLI authentication status
* :ansplugin:`pr_comment role <rstyczynski.github.pr_comment#role>` -- Adds comment to pull request for current branch
* :ansplugin:`pr_create role <rstyczynski.github.pr_create#role>` -- Creates a new pull request using GitHub CLI with customizable title and body
* :ansplugin:`pr_merge role <rstyczynski.github.pr_merge#role>` -- Merges a pull request using specified method (merge, squash, or rebase)
* :ansplugin:`pr_status_check role <rstyczynski.github.pr_status_check#role>` -- Checks pull request status including CI checks and review state
* :ansplugin:`pr_status_check_pause role <rstyczynski.github.pr_status_check_pause#role>` -- Waits for PR status checks to complete with configurable retries
* :ansplugin:`repo_clone role <rstyczynski.github.repo_clone#role>` -- Clones GitHub repository or updates existing clone with branch sync
* :ansplugin:`repo_commit role <rstyczynski.github.repo_commit#role>` -- Creates git commit with specified message if changes are staged
* :ansplugin:`repo_file_add role <rstyczynski.github.repo_file_add#role>` -- Copies file into repository and stages it for commit

.. toctree::
    :maxdepth: 1
    :hidden:

    branch_checkout_role
    branch_delete_role
    branch_pull_role
    branch_push_role
    branch_switch_role
    github_auth_role
    github_logout_role
    github_precheck_role
    pr_comment_role
    pr_create_role
    pr_merge_role
    pr_status_check_role
    pr_status_check_pause_role
    repo_clone_role
    repo_commit_role
    repo_file_add_role


.. seealso::

    List of :ref:`collections <list_of_collections>` with docs hosted here.
