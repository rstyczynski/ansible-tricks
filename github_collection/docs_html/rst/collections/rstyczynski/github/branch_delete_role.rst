.. Document meta

:orphan:

.. |antsibull-internal-nbsp| unicode:: 0xA0
    :trim:

.. meta::
  :antsibull-docs: 2.22.1

.. Anchors

.. _ansible_collections.rstyczynski.github.branch_delete_role:

.. Title

rstyczynski.github.branch_delete role -- Deletes branch both locally and remotely in idempotent manner
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. Collection note

.. note::
    This role is part of the `rstyczynski.github collection <https://galaxy.ansible.com/ui/repo/published/rstyczynski/github/>`_ (version 1.0.0).

    It is not included in ``ansible-core``.
    To check whether it is installed, run :code:`ansible-galaxy collection list`.

    To install it use: :code:`ansible\-galaxy collection install rstyczynski.github`.

    To use it in a playbook, specify: :code:`rstyczynski.github.branch_delete`.

.. contents::
   :local:
   :depth: 2

.. _ansible_collections.rstyczynski.github.branch_delete_role__entrypoint-main:

.. Entry point title

Entry point ``main`` -- Deletes branch both locally and remotely in idempotent manner
-------------------------------------------------------------------------------------

.. version_added


.. Deprecated


Synopsis
^^^^^^^^

.. Description

- Deletes a branch both locally and remotely in an idempotent manner

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
        <div class="ansibleOptionAnchor" id="parameter-main--branch_delete_base_branch"></div>

      .. _ansible_collections.rstyczynski.github.branch_delete_role__parameter-main__branch_delete_base_branch:

      .. rst-class:: ansible-option-title

      **branch_delete_base_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_delete_base_branch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Base branch to verify we're not deleting it


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_delete_current_branch"></div>

      .. _ansible_collections.rstyczynski.github.branch_delete_role__parameter-main__branch_delete_current_branch:

      .. rst-class:: ansible-option-title

      **branch_delete_current_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_delete_current_branch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Current branch name before deletion


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_delete_delete_branch"></div>

      .. _ansible_collections.rstyczynski.github.branch_delete_role__parameter-main__branch_delete_delete_branch:

      .. rst-class:: ansible-option-title

      **branch_delete_delete_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_delete_delete_branch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Branch name to delete


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_delete_delete_local_result"></div>

      .. _ansible_collections.rstyczynski.github.branch_delete_role__parameter-main__branch_delete_delete_local_result:

      .. rst-class:: ansible-option-title

      **branch_delete_delete_local_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_delete_delete_local_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of deleting local branch


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_delete_delete_remote_result"></div>

      .. _ansible_collections.rstyczynski.github.branch_delete_role__parameter-main__branch_delete_delete_remote_result:

      .. rst-class:: ansible-option-title

      **branch_delete_delete_remote_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_delete_delete_remote_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of deleting remote branch


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_delete_dest_path"></div>

      .. _ansible_collections.rstyczynski.github.branch_delete_role__parameter-main__branch_delete_dest_path:

      .. rst-class:: ansible-option-title

      **branch_delete_dest_path**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_delete_dest_path" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`path` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Path to git repository


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_delete_local_branch_check"></div>

      .. _ansible_collections.rstyczynski.github.branch_delete_role__parameter-main__branch_delete_local_branch_check:

      .. rst-class:: ansible-option-title

      **branch_delete_local_branch_check**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_delete_local_branch_check" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Check if branch exists locally


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_delete_new_branch"></div>

      .. _ansible_collections.rstyczynski.github.branch_delete_role__parameter-main__branch_delete_new_branch:

      .. rst-class:: ansible-option-title

      **branch_delete_new_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_delete_new_branch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      New branch context for validation


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_delete_remote_branch_check"></div>

      .. _ansible_collections.rstyczynski.github.branch_delete_role__parameter-main__branch_delete_remote_branch_check:

      .. rst-class:: ansible-option-title

      **branch_delete_remote_branch_check**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_delete_remote_branch_check" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Check if branch exists on remote


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
