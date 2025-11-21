.. Document meta

:orphan:

.. |antsibull-internal-nbsp| unicode:: 0xA0
    :trim:

.. meta::
  :antsibull-docs: 2.22.1

.. Anchors

.. _ansible_collections.rstyczynski.github.github_auth_role:

.. Title

rstyczynski.github.github_auth role -- Authenticates GitHub CLI using token from environment or .netrc
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. Collection note

.. note::
    This role is part of the `rstyczynski.github collection <https://galaxy.ansible.com/ui/repo/published/rstyczynski/github/>`_ (version 1.0.0).

    It is not included in ``ansible-core``.
    To check whether it is installed, run :code:`ansible-galaxy collection list`.

    To install it use: :code:`ansible\-galaxy collection install rstyczynski.github`.

    To use it in a playbook, specify: :code:`rstyczynski.github.github_auth`.

.. contents::
   :local:
   :depth: 2

.. _ansible_collections.rstyczynski.github.github_auth_role__entrypoint-main:

.. Entry point title

Entry point ``main`` -- Authenticates GitHub CLI using token from environment or .netrc
---------------------------------------------------------------------------------------

.. version_added


.. Deprecated


Synopsis
^^^^^^^^

.. Description

- Authenticates GitHub CLI using token from environment variables or .netrc file

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
        <div class="ansibleOptionAnchor" id="parameter-main--github_auth_gh_auth_result"></div>

      .. _ansible_collections.rstyczynski.github.github_auth_role__parameter-main__github_auth_gh_auth_result:

      .. rst-class:: ansible-option-title

      **github_auth_gh_auth_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--github_auth_gh_auth_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of authenticating with GitHub CLI


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--github_auth_gh_auth_status"></div>

      .. _ansible_collections.rstyczynski.github.github_auth_role__parameter-main__github_auth_gh_auth_status:

      .. rst-class:: ansible-option-title

      **github_auth_gh_auth_status**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--github_auth_gh_auth_status" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      GitHub CLI authentication status from github\_precheck


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--github_auth_gh_auth_verify"></div>

      .. _ansible_collections.rstyczynski.github.github_auth_role__parameter-main__github_auth_gh_auth_verify:

      .. rst-class:: ansible-option-title

      **github_auth_gh_auth_verify**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--github_auth_gh_auth_verify" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of verifying authentication


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--github_auth_gh_version"></div>

      .. _ansible_collections.rstyczynski.github.github_auth_role__parameter-main__github_auth_gh_version:

      .. rst-class:: ansible-option-title

      **github_auth_gh_version**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--github_auth_gh_version" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      GitHub CLI version check result from github\_precheck


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--github_auth_github_token"></div>

      .. _ansible_collections.rstyczynski.github.github_auth_role__parameter-main__github_auth_github_token:

      .. rst-class:: ansible-option-title

      **github_auth_github_token**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--github_auth_github_token" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] GitHub authentication token


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--github_auth_netrc_file"></div>

      .. _ansible_collections.rstyczynski.github.github_auth_role__parameter-main__github_auth_netrc_file:

      .. rst-class:: ansible-option-title

      **github_auth_netrc_file**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--github_auth_netrc_file" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of checking .netrc file existence


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--github_auth_netrc_token"></div>

      .. _ansible_collections.rstyczynski.github.github_auth_role__parameter-main__github_auth_netrc_token:

      .. rst-class:: ansible-option-title

      **github_auth_netrc_token**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--github_auth_netrc_token" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Token extracted from .netrc file


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
