.. Document meta

:orphan:

.. |antsibull-internal-nbsp| unicode:: 0xA0
    :trim:

.. meta::
  :antsibull-docs: 2.22.1

.. Anchors

.. _ansible_collections.rstyczynski.github.github_precheck_role:

.. Title

rstyczynski.github.github_precheck role -- Verifies system prerequisites including git installation and GitHub CLI authentication status
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. Collection note

.. note::
    This role is part of the `rstyczynski.github collection <https://galaxy.ansible.com/ui/repo/published/rstyczynski/github/>`_ (version 1.0.0).

    It is not included in ``ansible-core``.
    To check whether it is installed, run :code:`ansible-galaxy collection list`.

    To install it use: :code:`ansible\-galaxy collection install rstyczynski.github`.

    To use it in a playbook, specify: :code:`rstyczynski.github.github_precheck`.

.. contents::
   :local:
   :depth: 2

.. _ansible_collections.rstyczynski.github.github_precheck_role__entrypoint-main:

.. Entry point title

Entry point ``main`` -- Verifies system prerequisites including git installation and GitHub CLI authentication status
---------------------------------------------------------------------------------------------------------------------

.. version_added


.. Deprecated


Synopsis
^^^^^^^^

.. Description

- Checks if git is installed and displays version information
- Checks if GitHub CLI (gh) is installed and displays version
- Verifies GitHub CLI authentication status
- Provides warnings if prerequisites are not met

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
        <div class="ansibleOptionAnchor" id="parameter-main--github_precheck_gh_auth_status"></div>

      .. _ansible_collections.rstyczynski.github.github_precheck_role__parameter-main__github_precheck_gh_auth_status:

      .. rst-class:: ansible-option-title

      **github_precheck_gh_auth_status**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--github_precheck_gh_auth_status" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] GitHub CLI authentication status check result


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--github_precheck_gh_version"></div>

      .. _ansible_collections.rstyczynski.github.github_precheck_role__parameter-main__github_precheck_gh_version:

      .. rst-class:: ansible-option-title

      **github_precheck_gh_version**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--github_precheck_gh_version" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] GitHub CLI version information from command execution


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--github_precheck_git_version"></div>

      .. _ansible_collections.rstyczynski.github.github_precheck_role__parameter-main__github_precheck_git_version:

      .. rst-class:: ansible-option-title

      **github_precheck_git_version**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--github_precheck_git_version" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Git version information from command execution


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
