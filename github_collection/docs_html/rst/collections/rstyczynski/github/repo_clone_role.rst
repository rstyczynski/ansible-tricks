.. Document meta

:orphan:

.. |antsibull-internal-nbsp| unicode:: 0xA0
    :trim:

.. meta::
  :antsibull-docs: 2.22.1

.. Anchors

.. _ansible_collections.rstyczynski.github.repo_clone_role:

.. Title

rstyczynski.github.repo_clone role -- Clones GitHub repository or updates existing clone with branch sync
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. Collection note

.. note::
    This role is part of the `rstyczynski.github collection <https://galaxy.ansible.com/ui/repo/published/rstyczynski/github/>`_ (version 1.0.0).

    It is not included in ``ansible-core``.
    To check whether it is installed, run :code:`ansible-galaxy collection list`.

    To install it use: :code:`ansible\-galaxy collection install rstyczynski.github`.

    To use it in a playbook, specify: :code:`rstyczynski.github.repo_clone`.

.. contents::
   :local:
   :depth: 2

.. _ansible_collections.rstyczynski.github.repo_clone_role__entrypoint-main:

.. Entry point title

Entry point ``main`` -- Clones GitHub repository or updates existing clone with branch sync
-------------------------------------------------------------------------------------------

.. version_added


.. Deprecated


Synopsis
^^^^^^^^

.. Description

- Clones a GitHub repository or updates an existing clone, handling branch synchronization

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
        <div class="ansibleOptionAnchor" id="parameter-main--repo_clone_base_branch"></div>

      .. _ansible_collections.rstyczynski.github.repo_clone_role__parameter-main__repo_clone_base_branch:

      .. rst-class:: ansible-option-title

      **repo_clone_base_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_clone_base_branch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Base branch name (e.g., main, master)


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_clone_clone_result"></div>

      .. _ansible_collections.rstyczynski.github.repo_clone_role__parameter-main__repo_clone_clone_result:

      .. rst-class:: ansible-option-title

      **repo_clone_clone_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_clone_clone_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of git clone operation


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_clone_current_branch"></div>

      .. _ansible_collections.rstyczynski.github.repo_clone_role__parameter-main__repo_clone_current_branch:

      .. rst-class:: ansible-option-title

      **repo_clone_current_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_clone_current_branch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Current active branch name


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_clone_dest_path"></div>

      .. _ansible_collections.rstyczynski.github.repo_clone_role__parameter-main__repo_clone_dest_path:

      .. rst-class:: ansible-option-title

      **repo_clone_dest_path**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_clone_dest_path" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`path` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Local destination path for repository


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_clone_fetch_result"></div>

      .. _ansible_collections.rstyczynski.github.repo_clone_role__parameter-main__repo_clone_fetch_result:

      .. rst-class:: ansible-option-title

      **repo_clone_fetch_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_clone_fetch_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of fetching updates from remote


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_clone_new_branch"></div>

      .. _ansible_collections.rstyczynski.github.repo_clone_role__parameter-main__repo_clone_new_branch:

      .. rst-class:: ansible-option-title

      **repo_clone_new_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_clone_new_branch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      New branch name for feature development


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_clone_pull_result"></div>

      .. _ansible_collections.rstyczynski.github.repo_clone_role__parameter-main__repo_clone_pull_result:

      .. rst-class:: ansible-option-title

      **repo_clone_pull_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_clone_pull_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of pulling latest changes


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_clone_remote_branch_check"></div>

      .. _ansible_collections.rstyczynski.github.repo_clone_role__parameter-main__repo_clone_remote_branch_check:

      .. rst-class:: ansible-option-title

      **repo_clone_remote_branch_check**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_clone_remote_branch_check" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Check if local branch exists on remote


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_clone_repo_stat"></div>

      .. _ansible_collections.rstyczynski.github.repo_clone_role__parameter-main__repo_clone_repo_stat:

      .. rst-class:: ansible-option-title

      **repo_clone_repo_stat**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_clone_repo_stat" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Repository directory existence check


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_clone_repo_url"></div>

      .. _ansible_collections.rstyczynski.github.repo_clone_role__parameter-main__repo_clone_repo_url:

      .. rst-class:: ansible-option-title

      **repo_clone_repo_url**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_clone_repo_url" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      GitHub repository URL to clone


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
