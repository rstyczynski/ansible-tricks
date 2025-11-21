.. Document meta

:orphan:

.. |antsibull-internal-nbsp| unicode:: 0xA0
    :trim:

.. meta::
  :antsibull-docs: 2.22.1

.. Anchors

.. _ansible_collections.rstyczynski.github.pr_create_role:

.. Title

rstyczynski.github.pr_create role -- Creates a new pull request using GitHub CLI with customizable title and body
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. Collection note

.. note::
    This role is part of the `rstyczynski.github collection <https://galaxy.ansible.com/ui/repo/published/rstyczynski/github/>`_ (version 1.0.0).

    It is not included in ``ansible-core``.
    To check whether it is installed, run :code:`ansible-galaxy collection list`.

    To install it use: :code:`ansible\-galaxy collection install rstyczynski.github`.

    To use it in a playbook, specify: :code:`rstyczynski.github.pr_create`.

.. contents::
   :local:
   :depth: 2

.. _ansible_collections.rstyczynski.github.pr_create_role__entrypoint-main:

.. Entry point title

Entry point ``main`` -- Creates a new pull request using GitHub CLI with customizable title and body
----------------------------------------------------------------------------------------------------

.. version_added


.. Deprecated


Synopsis
^^^^^^^^

.. Description

- Creates a new pull request using GitHub CLI with customizable title and body

.. Requirements


.. Options

Parameters
^^^^^^^^^^

.. tabularcolumns:: \X{1}{3}\X{2}{3}

.. list-table::
  :width: 100%
  :widths: auto
  :header-rows: 1
  :class: longtable ansible-option-table

  * - Parameter
    - Comments

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_create_base_branch"></div>

      .. _ansible_collections.rstyczynski.github.pr_create_role__parameter-main__pr_create_base_branch:

      .. rst-class:: ansible-option-title

      **pr_create_base_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_create_base_branch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Base branch for PR


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_create_current_branch"></div>

      .. _ansible_collections.rstyczynski.github.pr_create_role__parameter-main__pr_create_current_branch:

      .. rst-class:: ansible-option-title

      **pr_create_current_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_create_current_branch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Current branch name


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_create_dest_path"></div>

      .. _ansible_collections.rstyczynski.github.pr_create_role__parameter-main__pr_create_dest_path:

      .. rst-class:: ansible-option-title

      **pr_create_dest_path**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_create_dest_path" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Destination path to the git repository


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_create_existing_pr"></div>

      .. _ansible_collections.rstyczynski.github.pr_create_role__parameter-main__pr_create_existing_pr:

      .. rst-class:: ansible-option-title

      **pr_create_existing_pr**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_create_existing_pr" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Existing PR number if found


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_create_final_pr_body"></div>

      .. _ansible_collections.rstyczynski.github.pr_create_role__parameter-main__pr_create_final_pr_body:

      .. rst-class:: ansible-option-title

      **pr_create_final_pr_body**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_create_final_pr_body" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Final PR body to use


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_create_final_pr_title"></div>

      .. _ansible_collections.rstyczynski.github.pr_create_role__parameter-main__pr_create_final_pr_title:

      .. rst-class:: ansible-option-title

      **pr_create_final_pr_title**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_create_final_pr_title" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Final PR title to use


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_create_gh_auth_status"></div>

      .. _ansible_collections.rstyczynski.github.pr_create_role__parameter-main__pr_create_gh_auth_status:

      .. rst-class:: ansible-option-title

      **pr_create_gh_auth_status**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_create_gh_auth_status" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      GitHub CLI authentication status


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_create_gh_version"></div>

      .. _ansible_collections.rstyczynski.github.pr_create_role__parameter-main__pr_create_gh_version:

      .. rst-class:: ansible-option-title

      **pr_create_gh_version**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_create_gh_version" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      GitHub CLI version check result


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_create_pr_body"></div>

      .. _ansible_collections.rstyczynski.github.pr_create_role__parameter-main__pr_create_pr_body:

      .. rst-class:: ansible-option-title

      **pr_create_pr_body**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_create_pr_body" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      PR body/description (optional)


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_create_pr_create_result"></div>

      .. _ansible_collections.rstyczynski.github.pr_create_role__parameter-main__pr_create_pr_create_result:

      .. rst-class:: ansible-option-title

      **pr_create_pr_create_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_create_pr_create_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of creating PR


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_create_pr_title"></div>

      .. _ansible_collections.rstyczynski.github.pr_create_role__parameter-main__pr_create_pr_title:

      .. rst-class:: ansible-option-title

      **pr_create_pr_title**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_create_pr_title" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      PR title (optional)


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_create_remote_branch_check"></div>

      .. _ansible_collections.rstyczynski.github.pr_create_role__parameter-main__pr_create_remote_branch_check:

      .. rst-class:: ansible-option-title

      **pr_create_remote_branch_check**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_create_remote_branch_check" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of checking if branch is pushed


      .. raw:: html

        </div>


.. Attributes


.. Notes


.. Seealso





.. Extra links

Collection links
~~~~~~~~~~~~~~~~

.. ansible-links::

  - title: "Issue Tracker"
    url: "https://github.com/rstyczynski/ansible-tricks/issues"
    external: true
  - title: "Repository (Sources)"
    url: "https://github.com/rstyczynski/ansible-tricks"
    external: true


.. Parsing errors
