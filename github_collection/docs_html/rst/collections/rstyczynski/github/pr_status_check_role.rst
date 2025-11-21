.. Document meta

:orphan:

.. |antsibull-internal-nbsp| unicode:: 0xA0
    :trim:

.. meta::
  :antsibull-docs: 2.22.1

.. Anchors

.. _ansible_collections.rstyczynski.github.pr_status_check_role:

.. Title

rstyczynski.github.pr_status_check role -- Checks pull request status including CI checks and review state
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. Collection note

.. note::
    This role is part of the `rstyczynski.github collection <https://galaxy.ansible.com/ui/repo/published/rstyczynski/github/>`_ (version 1.0.0).

    It is not included in ``ansible-core``.
    To check whether it is installed, run :code:`ansible-galaxy collection list`.

    To install it use: :code:`ansible\-galaxy collection install rstyczynski.github`.

    To use it in a playbook, specify: :code:`rstyczynski.github.pr_status_check`.

.. contents::
   :local:
   :depth: 2

.. _ansible_collections.rstyczynski.github.pr_status_check_role__entrypoint-main:

.. Entry point title

Entry point ``main`` -- Checks pull request status including CI checks and review state
---------------------------------------------------------------------------------------

.. version_added


.. Deprecated


Synopsis
^^^^^^^^

.. Description

- Checks pull request status including CI checks and review state

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
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_current_branch"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_role__parameter-main__pr_status_check_current_branch:

      .. rst-class:: ansible-option-title

      **pr_status_check_current_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_current_branch" title="Permalink to this option"></a>

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
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_dest_path"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_role__parameter-main__pr_status_check_dest_path:

      .. rst-class:: ansible-option-title

      **pr_status_check_dest_path**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_dest_path" title="Permalink to this option"></a>

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
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_failed_checks"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_role__parameter-main__pr_status_check_failed_checks:

      .. rst-class:: ansible-option-title

      **pr_status_check_failed_checks**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_failed_checks" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`list` / :ansible-option-elements:`elements=string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Failed status checks list


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_gh_auth_status"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_role__parameter-main__pr_status_check_gh_auth_status:

      .. rst-class:: ansible-option-title

      **pr_status_check_gh_auth_status**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_gh_auth_status" title="Permalink to this option"></a>

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
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_gh_version"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_role__parameter-main__pr_status_check_gh_version:

      .. rst-class:: ansible-option-title

      **pr_status_check_gh_version**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_gh_version" title="Permalink to this option"></a>

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
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_has_pending_checks"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_role__parameter-main__pr_status_check_has_pending_checks:

      .. rst-class:: ansible-option-title

      **pr_status_check_has_pending_checks**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_has_pending_checks" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`boolean`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Boolean flag if pending checks exist


      .. rst-class:: ansible-option-line

      :ansible-option-choices:`Choices:`

      - :ansible-option-choices-entry:`false`
      - :ansible-option-choices-entry:`true`


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_pending_checks"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_role__parameter-main__pr_status_check_pending_checks:

      .. rst-class:: ansible-option-title

      **pr_status_check_pending_checks**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_pending_checks" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`list` / :ansible-option-elements:`elements=string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Pending status checks list


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_pr_number"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_role__parameter-main__pr_status_check_pr_number:

      .. rst-class:: ansible-option-title

      **pr_status_check_pr_number**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_pr_number" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Pull request number


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_pr_status"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_role__parameter-main__pr_status_check_pr_status:

      .. rst-class:: ansible-option-title

      **pr_status_check_pr_status**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_pr_status" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Pull request status checks result


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_status_checks"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_role__parameter-main__pr_status_check_status_checks:

      .. rst-class:: ansible-option-title

      **pr_status_check_status_checks**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_status_checks" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`list` / :ansible-option-elements:`elements=string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Parsed status checks list


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
