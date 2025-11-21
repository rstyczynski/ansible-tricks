.. Document meta

:orphan:

.. |antsibull-internal-nbsp| unicode:: 0xA0
    :trim:

.. meta::
  :antsibull-docs: 2.22.1

.. Anchors

.. _ansible_collections.rstyczynski.github.repo_commit_role:

.. Title

rstyczynski.github.repo_commit role -- Creates git commit with specified message if changes are staged
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. Collection note

.. note::
    This role is part of the `rstyczynski.github collection <https://galaxy.ansible.com/ui/repo/published/rstyczynski/github/>`_ (version 1.0.0).

    It is not included in ``ansible-core``.
    To check whether it is installed, run :code:`ansible-galaxy collection list`.

    To install it use: :code:`ansible\-galaxy collection install rstyczynski.github`.

    To use it in a playbook, specify: :code:`rstyczynski.github.repo_commit`.

.. contents::
   :local:
   :depth: 2

.. _ansible_collections.rstyczynski.github.repo_commit_role__entrypoint-main:

.. Entry point title

Entry point ``main`` -- Creates git commit with specified message if changes are staged
---------------------------------------------------------------------------------------

.. version_added


.. Deprecated


Synopsis
^^^^^^^^

.. Description

- Creates a git commit with specified message if changes are staged

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
        <div class="ansibleOptionAnchor" id="parameter-main--repo_commit_commit_message"></div>

      .. _ansible_collections.rstyczynski.github.repo_commit_role__parameter-main__repo_commit_commit_message:

      .. rst-class:: ansible-option-title

      **repo_commit_commit_message**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_commit_commit_message" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Commit message text


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_commit_commit_result"></div>

      .. _ansible_collections.rstyczynski.github.repo_commit_role__parameter-main__repo_commit_commit_result:

      .. rst-class:: ansible-option-title

      **repo_commit_commit_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_commit_commit_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of git commit operation


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_commit_dest_path"></div>

      .. _ansible_collections.rstyczynski.github.repo_commit_role__parameter-main__repo_commit_dest_path:

      .. rst-class:: ansible-option-title

      **repo_commit_dest_path**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_commit_dest_path" title="Permalink to this option"></a>

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
        <div class="ansibleOptionAnchor" id="parameter-main--repo_commit_file_path"></div>

      .. _ansible_collections.rstyczynski.github.repo_commit_role__parameter-main__repo_commit_file_path:

      .. rst-class:: ansible-option-title

      **repo_commit_file_path**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_commit_file_path" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      File path for auto\-generated commit message


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_commit_final_message"></div>

      .. _ansible_collections.rstyczynski.github.repo_commit_role__parameter-main__repo_commit_final_message:

      .. rst-class:: ansible-option-title

      **repo_commit_final_message**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_commit_final_message" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Final commit message used


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_commit_git_status"></div>

      .. _ansible_collections.rstyczynski.github.repo_commit_role__parameter-main__repo_commit_git_status:

      .. rst-class:: ansible-option-title

      **repo_commit_git_status**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_commit_git_status" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Git status before commit


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
