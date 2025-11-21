.. Document meta

:orphan:

.. |antsibull-internal-nbsp| unicode:: 0xA0
    :trim:

.. meta::
  :antsibull-docs: 2.22.1

.. Anchors

.. _ansible_collections.rstyczynski.github.github_logout_role:

.. Title

rstyczynski.github.github_logout role -- Logs out from GitHub CLI and clears authentication state
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. Collection note

.. note::
    This role is part of the `rstyczynski.github collection <https://galaxy.ansible.com/ui/repo/published/rstyczynski/github/>`_ (version 1.0.0).

    It is not included in ``ansible-core``.
    To check whether it is installed, run :code:`ansible-galaxy collection list`.

    To install it use: :code:`ansible\-galaxy collection install rstyczynski.github`.

    To use it in a playbook, specify: :code:`rstyczynski.github.github_logout`.

.. contents::
   :local:
   :depth: 2

.. _ansible_collections.rstyczynski.github.github_logout_role__entrypoint-main:

.. Entry point title

Entry point ``main`` -- Logs out from GitHub CLI and clears authentication state
--------------------------------------------------------------------------------

.. version_added


.. Deprecated


Synopsis
^^^^^^^^

.. Description

- Logs out from GitHub CLI and clears authentication state

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
        <div class="ansibleOptionAnchor" id="parameter-main--github_logout_gh_auth_result"></div>

      .. _ansible_collections.rstyczynski.github.github_logout_role__parameter-main__github_logout_gh_auth_result:

      .. rst-class:: ansible-option-title

      **github_logout_gh_auth_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--github_logout_gh_auth_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      GitHub CLI authentication result to verify logout needed


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--github_logout_gh_version"></div>

      .. _ansible_collections.rstyczynski.github.github_logout_role__parameter-main__github_logout_gh_version:

      .. rst-class:: ansible-option-title

      **github_logout_gh_version**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--github_logout_gh_version" title="Permalink to this option"></a>

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
        <div class="ansibleOptionAnchor" id="parameter-main--github_logout_result"></div>

      .. _ansible_collections.rstyczynski.github.github_logout_role__parameter-main__github_logout_result:

      .. rst-class:: ansible-option-title

      **github_logout_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--github_logout_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of GitHub CLI logout operation


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
