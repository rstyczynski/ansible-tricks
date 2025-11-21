.. Document meta

:orphan:

.. |antsibull-internal-nbsp| unicode:: 0xA0
    :trim:

.. meta::
  :antsibull-docs: 2.22.1

.. Anchors

.. _ansible_collections.rstyczynski.github.pr_merge_role:

.. Title

rstyczynski.github.pr_merge role -- Merges a pull request using specified method (merge, squash, or rebase)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. Collection note

.. note::
    This role is part of the `rstyczynski.github collection <https://galaxy.ansible.com/ui/repo/published/rstyczynski/github/>`_ (version 1.0.0).

    It is not included in ``ansible-core``.
    To check whether it is installed, run :code:`ansible-galaxy collection list`.

    To install it use: :code:`ansible\-galaxy collection install rstyczynski.github`.

    To use it in a playbook, specify: :code:`rstyczynski.github.pr_merge`.

.. contents::
   :local:
   :depth: 2

.. _ansible_collections.rstyczynski.github.pr_merge_role__entrypoint-main:

.. Entry point title

Entry point ``main`` -- Merges a pull request using specified method (merge, squash, or rebase)
-----------------------------------------------------------------------------------------------

.. version_added


.. Deprecated


Synopsis
^^^^^^^^

.. Description

- Merges a pull request using specified method (merge, squash, or rebase)

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
        <div class="ansibleOptionAnchor" id="parameter-main--pr_merge_current_branch"></div>

      .. _ansible_collections.rstyczynski.github.pr_merge_role__parameter-main__pr_merge_current_branch:

      .. rst-class:: ansible-option-title

      **pr_merge_current_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_merge_current_branch" title="Permalink to this option"></a>

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
        <div class="ansibleOptionAnchor" id="parameter-main--pr_merge_dest_path"></div>

      .. _ansible_collections.rstyczynski.github.pr_merge_role__parameter-main__pr_merge_dest_path:

      .. rst-class:: ansible-option-title

      **pr_merge_dest_path**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_merge_dest_path" title="Permalink to this option"></a>

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
        <div class="ansibleOptionAnchor" id="parameter-main--pr_merge_failed_checks_for_merge"></div>

      .. _ansible_collections.rstyczynski.github.pr_merge_role__parameter-main__pr_merge_failed_checks_for_merge:

      .. rst-class:: ansible-option-title

      **pr_merge_failed_checks_for_merge**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_merge_failed_checks_for_merge" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`list` / :ansible-option-elements:`elements=string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Failed status checks


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_merge_pending_checks_for_merge"></div>

      .. _ansible_collections.rstyczynski.github.pr_merge_role__parameter-main__pr_merge_pending_checks_for_merge:

      .. rst-class:: ansible-option-title

      **pr_merge_pending_checks_for_merge**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_merge_pending_checks_for_merge" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`list` / :ansible-option-elements:`elements=string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Pending status checks


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_merge_pr_info"></div>

      .. _ansible_collections.rstyczynski.github.pr_merge_role__parameter-main__pr_merge_pr_info:

      .. rst-class:: ansible-option-title

      **pr_merge_pr_info**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_merge_pr_info" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Parsed PR state information


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_merge_pr_merge_method"></div>

      .. _ansible_collections.rstyczynski.github.pr_merge_role__parameter-main__pr_merge_pr_merge_method:

      .. rst-class:: ansible-option-title

      **pr_merge_pr_merge_method**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_merge_pr_merge_method" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Merge method \- merge, squash, or rebase


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_merge_pr_merge_result"></div>

      .. _ansible_collections.rstyczynski.github.pr_merge_role__parameter-main__pr_merge_pr_merge_result:

      .. rst-class:: ansible-option-title

      **pr_merge_pr_merge_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_merge_pr_merge_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of merging PR


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_merge_pr_number"></div>

      .. _ansible_collections.rstyczynski.github.pr_merge_role__parameter-main__pr_merge_pr_number:

      .. rst-class:: ansible-option-title

      **pr_merge_pr_number**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_merge_pr_number" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] PR number for current branch


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_merge_pr_state"></div>

      .. _ansible_collections.rstyczynski.github.pr_merge_role__parameter-main__pr_merge_pr_state:

      .. rst-class:: ansible-option-title

      **pr_merge_pr_state**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_merge_pr_state" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] PR state information


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_merge_pr_status_checks_for_merge"></div>

      .. _ansible_collections.rstyczynski.github.pr_merge_role__parameter-main__pr_merge_pr_status_checks_for_merge:

      .. rst-class:: ansible-option-title

      **pr_merge_pr_status_checks_for_merge**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_merge_pr_status_checks_for_merge" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] PR status checks for merge


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_merge_status_checks_for_merge"></div>

      .. _ansible_collections.rstyczynski.github.pr_merge_role__parameter-main__pr_merge_status_checks_for_merge:

      .. rst-class:: ansible-option-title

      **pr_merge_status_checks_for_merge**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_merge_status_checks_for_merge" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`list` / :ansible-option-elements:`elements=string`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Parsed status checks for merge


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
