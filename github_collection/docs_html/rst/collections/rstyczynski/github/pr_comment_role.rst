.. Document meta

:orphan:

.. |antsibull-internal-nbsp| unicode:: 0xA0
    :trim:

.. meta::
  :antsibull-docs: 2.22.1

.. Anchors

.. _ansible_collections.rstyczynski.github.pr_comment_role:

.. Title

rstyczynski.github.pr_comment role -- Adds comment to pull request for current branch
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. Collection note

.. note::
    This role is part of the `rstyczynski.github collection <https://galaxy.ansible.com/ui/repo/published/rstyczynski/github/>`_ (version 1.0.0).

    It is not included in ``ansible-core``.
    To check whether it is installed, run :code:`ansible-galaxy collection list`.

    To install it use: :code:`ansible\-galaxy collection install rstyczynski.github`.

    To use it in a playbook, specify: :code:`rstyczynski.github.pr_comment`.

.. contents::
   :local:
   :depth: 2

.. _ansible_collections.rstyczynski.github.pr_comment_role__entrypoint-main:

.. Entry point title

Entry point ``main`` -- Adds comment to pull request for current branch
-----------------------------------------------------------------------

.. version_added


.. Deprecated


Synopsis
^^^^^^^^

.. Description

- Adds a comment to the pull request for the current branch

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
        <div class="ansibleOptionAnchor" id="parameter-main--pr_comment_comment_result"></div>

      .. _ansible_collections.rstyczynski.github.pr_comment_role__parameter-main__pr_comment_comment_result:

      .. rst-class:: ansible-option-title

      **pr_comment_comment_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_comment_comment_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of adding comment


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_comment_current_branch"></div>

      .. _ansible_collections.rstyczynski.github.pr_comment_role__parameter-main__pr_comment_current_branch:

      .. rst-class:: ansible-option-title

      **pr_comment_current_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_comment_current_branch" title="Permalink to this option"></a>

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
        <div class="ansibleOptionAnchor" id="parameter-main--pr_comment_dest_path"></div>

      .. _ansible_collections.rstyczynski.github.pr_comment_role__parameter-main__pr_comment_dest_path:

      .. rst-class:: ansible-option-title

      **pr_comment_dest_path**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_comment_dest_path" title="Permalink to this option"></a>

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
        <div class="ansibleOptionAnchor" id="parameter-main--pr_comment_pr_comment"></div>

      .. _ansible_collections.rstyczynski.github.pr_comment_role__parameter-main__pr_comment_pr_comment:

      .. rst-class:: ansible-option-title

      **pr_comment_pr_comment**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_comment_pr_comment" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Comment text to add to pull request


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_comment_pr_number"></div>

      .. _ansible_collections.rstyczynski.github.pr_comment_role__parameter-main__pr_comment_pr_number:

      .. rst-class:: ansible-option-title

      **pr_comment_pr_number**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_comment_pr_number" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Pull request number


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
