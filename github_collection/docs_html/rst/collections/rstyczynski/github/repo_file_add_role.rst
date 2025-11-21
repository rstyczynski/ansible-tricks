.. Document meta

:orphan:

.. |antsibull-internal-nbsp| unicode:: 0xA0
    :trim:

.. meta::
  :antsibull-docs: 2.22.1

.. Anchors

.. _ansible_collections.rstyczynski.github.repo_file_add_role:

.. Title

rstyczynski.github.repo_file_add role -- Copies file into repository and stages it for commit
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. Collection note

.. note::
    This role is part of the `rstyczynski.github collection <https://galaxy.ansible.com/ui/repo/published/rstyczynski/github/>`_ (version 1.0.0).

    It is not included in ``ansible-core``.
    To check whether it is installed, run :code:`ansible-galaxy collection list`.

    To install it use: :code:`ansible\-galaxy collection install rstyczynski.github`.

    To use it in a playbook, specify: :code:`rstyczynski.github.repo_file_add`.

.. contents::
   :local:
   :depth: 2

.. _ansible_collections.rstyczynski.github.repo_file_add_role__entrypoint-main:

.. Entry point title

Entry point ``main`` -- Copies file into repository and stages it for commit
----------------------------------------------------------------------------

.. version_added


.. Deprecated


Synopsis
^^^^^^^^

.. Description

- Copies a file into repository and stages it for commit

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
        <div class="ansibleOptionAnchor" id="parameter-main--repo_file_add_copy_result"></div>

      .. _ansible_collections.rstyczynski.github.repo_file_add_role__parameter-main__repo_file_add_copy_result:

      .. rst-class:: ansible-option-title

      **repo_file_add_copy_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_file_add_copy_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of copying file


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_file_add_dest_path"></div>

      .. _ansible_collections.rstyczynski.github.repo_file_add_role__parameter-main__repo_file_add_dest_path:

      .. rst-class:: ansible-option-title

      **repo_file_add_dest_path**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_file_add_dest_path" title="Permalink to this option"></a>

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
        <div class="ansibleOptionAnchor" id="parameter-main--repo_file_add_detected_file_path"></div>

      .. _ansible_collections.rstyczynski.github.repo_file_add_role__parameter-main__repo_file_add_detected_file_path:

      .. rst-class:: ansible-option-title

      **repo_file_add_detected_file_path**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_file_add_detected_file_path" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Auto\-detected file path from source


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_file_add_file_path"></div>

      .. _ansible_collections.rstyczynski.github.repo_file_add_role__parameter-main__repo_file_add_file_path:

      .. rst-class:: ansible-option-title

      **repo_file_add_file_path**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_file_add_file_path" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Destination file path in repository (auto\-detected from source if not provided)


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_file_add_file_source"></div>

      .. _ansible_collections.rstyczynski.github.repo_file_add_role__parameter-main__repo_file_add_file_source:

      .. rst-class:: ansible-option-title

      **repo_file_add_file_source**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_file_add_file_source" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`path` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Source file path to copy from


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_file_add_file_stat"></div>

      .. _ansible_collections.rstyczynski.github.repo_file_add_role__parameter-main__repo_file_add_file_stat:

      .. rst-class:: ansible-option-title

      **repo_file_add_file_stat**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_file_add_file_stat" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] File existence check result


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_file_add_git_add_result"></div>

      .. _ansible_collections.rstyczynski.github.repo_file_add_role__parameter-main__repo_file_add_git_add_result:

      .. rst-class:: ansible-option-title

      **repo_file_add_git_add_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_file_add_git_add_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of git add operation


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--repo_file_add_git_status"></div>

      .. _ansible_collections.rstyczynski.github.repo_file_add_role__parameter-main__repo_file_add_git_status:

      .. rst-class:: ansible-option-title

      **repo_file_add_git_status**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--repo_file_add_git_status" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Git status for the file


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
