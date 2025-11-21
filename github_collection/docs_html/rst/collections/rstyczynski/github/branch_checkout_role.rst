.. Document meta

:orphan:

.. |antsibull-internal-nbsp| unicode:: 0xA0
    :trim:

.. meta::
  :antsibull-docs: 2.22.1

.. Anchors

.. _ansible_collections.rstyczynski.github.branch_checkout_role:

.. Title

rstyczynski.github.branch_checkout role -- Checks out or creates a new branch, with optional push to remote
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. Collection note

.. note::
    This role is part of the `rstyczynski.github collection <https://galaxy.ansible.com/ui/repo/published/rstyczynski/github/>`_ (version 1.0.0).

    It is not included in ``ansible-core``.
    To check whether it is installed, run :code:`ansible-galaxy collection list`.

    To install it use: :code:`ansible\-galaxy collection install rstyczynski.github`.

    To use it in a playbook, specify: :code:`rstyczynski.github.branch_checkout`.

.. contents::
   :local:
   :depth: 2

.. _ansible_collections.rstyczynski.github.branch_checkout_role__entrypoint-main:

.. Entry point title

Entry point ``main`` -- Checks out or creates a new branch, with optional push to remote
----------------------------------------------------------------------------------------

.. version_added


.. Deprecated


Synopsis
^^^^^^^^

.. Description

- Checks out or creates a new branch, with optional push to remote

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
        <div class="ansibleOptionAnchor" id="parameter-main--branch_checkout_base_branch"></div>

      .. _ansible_collections.rstyczynski.github.branch_checkout_role__parameter-main__branch_checkout_base_branch:

      .. rst-class:: ansible-option-title

      **branch_checkout_base_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_checkout_base_branch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Base branch name to checkout before creating


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_checkout_branch_check"></div>

      .. _ansible_collections.rstyczynski.github.branch_checkout_role__parameter-main__branch_checkout_branch_check:

      .. rst-class:: ansible-option-title

      **branch_checkout_branch_check**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_checkout_branch_check" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of checking if branch exists locally


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_checkout_checkout_result"></div>

      .. _ansible_collections.rstyczynski.github.branch_checkout_role__parameter-main__branch_checkout_checkout_result:

      .. rst-class:: ansible-option-title

      **branch_checkout_checkout_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_checkout_checkout_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of checking out existing branch


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_checkout_create_branch_result"></div>

      .. _ansible_collections.rstyczynski.github.branch_checkout_role__parameter-main__branch_checkout_create_branch_result:

      .. rst-class:: ansible-option-title

      **branch_checkout_create_branch_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_checkout_create_branch_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of creating new branch


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_checkout_current_branch"></div>

      .. _ansible_collections.rstyczynski.github.branch_checkout_role__parameter-main__branch_checkout_current_branch:

      .. rst-class:: ansible-option-title

      **branch_checkout_current_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_checkout_current_branch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Current branch after checkout


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_checkout_current_branch_before_base"></div>

      .. _ansible_collections.rstyczynski.github.branch_checkout_role__parameter-main__branch_checkout_current_branch_before_base:

      .. rst-class:: ansible-option-title

      **branch_checkout_current_branch_before_base**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_checkout_current_branch_before_base" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Current branch before base checkout


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_checkout_current_branch_before_checkout"></div>

      .. _ansible_collections.rstyczynski.github.branch_checkout_role__parameter-main__branch_checkout_current_branch_before_checkout:

      .. rst-class:: ansible-option-title

      **branch_checkout_current_branch_before_checkout**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_checkout_current_branch_before_checkout" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Current branch before checkout


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_checkout_current_branch_before_switch"></div>

      .. _ansible_collections.rstyczynski.github.branch_checkout_role__parameter-main__branch_checkout_current_branch_before_switch:

      .. rst-class:: ansible-option-title

      **branch_checkout_current_branch_before_switch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_checkout_current_branch_before_switch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Current branch before switching


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_checkout_dest_path"></div>

      .. _ansible_collections.rstyczynski.github.branch_checkout_role__parameter-main__branch_checkout_dest_path:

      .. rst-class:: ansible-option-title

      **branch_checkout_dest_path**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_checkout_dest_path" title="Permalink to this option"></a>

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
        <div class="ansibleOptionAnchor" id="parameter-main--branch_checkout_new_branch"></div>

      .. _ansible_collections.rstyczynski.github.branch_checkout_role__parameter-main__branch_checkout_new_branch:

      .. rst-class:: ansible-option-title

      **branch_checkout_new_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_checkout_new_branch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`string` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Name of the branch to checkout or create


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_checkout_push_branch_result"></div>

      .. _ansible_collections.rstyczynski.github.branch_checkout_role__parameter-main__branch_checkout_push_branch_result:

      .. rst-class:: ansible-option-title

      **branch_checkout_push_branch_result**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_checkout_push_branch_result" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of pushing branch to remote


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_checkout_push_new_branch"></div>

      .. _ansible_collections.rstyczynski.github.branch_checkout_role__parameter-main__branch_checkout_push_new_branch:

      .. rst-class:: ansible-option-title

      **branch_checkout_push_new_branch**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_checkout_push_new_branch" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`boolean`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Whether to push new branch to remote


      .. rst-class:: ansible-option-line

      :ansible-option-choices:`Choices:`

      - :ansible-option-choices-entry:`false`
      - :ansible-option-choices-entry:`true`


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--branch_checkout_remote_branch_check"></div>

      .. _ansible_collections.rstyczynski.github.branch_checkout_role__parameter-main__branch_checkout_remote_branch_check:

      .. rst-class:: ansible-option-title

      **branch_checkout_remote_branch_check**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--branch_checkout_remote_branch_check" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`dictionary`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      [OUTPUT] Result of checking if branch exists remotely


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
