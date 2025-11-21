.. Document meta

:orphan:

.. |antsibull-internal-nbsp| unicode:: 0xA0
    :trim:

.. meta::
  :antsibull-docs: 2.22.1

.. Anchors

.. _ansible_collections.rstyczynski.github.pr_status_check_pause_role:

.. Title

rstyczynski.github.pr_status_check_pause role -- Waits for PR status checks to complete with configurable retries
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. Collection note

.. note::
    This role is part of the `rstyczynski.github collection <https://galaxy.ansible.com/ui/repo/published/rstyczynski/github/>`_ (version 1.0.0).

    It is not included in ``ansible-core``.
    To check whether it is installed, run :code:`ansible-galaxy collection list`.

    To install it use: :code:`ansible\-galaxy collection install rstyczynski.github`.

    To use it in a playbook, specify: :code:`rstyczynski.github.pr_status_check_pause`.

.. contents::
   :local:
   :depth: 2

.. _ansible_collections.rstyczynski.github.pr_status_check_pause_role__entrypoint-main:

.. Entry point title

Entry point ``main`` -- Waits for PR status checks to complete with configurable retries
----------------------------------------------------------------------------------------

.. version_added


.. Deprecated


Synopsis
^^^^^^^^

.. Description

- Waits for PR status checks to complete with configurable retries and delays

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
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_has_pending_checks"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_pause_role__parameter-main__pr_status_check_has_pending_checks:

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

      [OUTPUT] Updated flag after checking status (inherited from pr\_status\_check)


      .. rst-class:: ansible-option-line

      :ansible-option-choices:`Choices:`

      - :ansible-option-choices-entry:`false`
      - :ansible-option-choices-entry:`true`


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_pause_attempt_number"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_pause_role__parameter-main__pr_status_check_pause_attempt_number:

      .. rst-class:: ansible-option-title

      **pr_status_check_pause_attempt_number**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_pause_attempt_number" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`integer` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Current attempt number in retry loop


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_pause_has_pending_checks"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_pause_role__parameter-main__pr_status_check_pause_has_pending_checks:

      .. rst-class:: ansible-option-title

      **pr_status_check_pause_has_pending_checks**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_pause_has_pending_checks" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`boolean`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Flag indicating if pending checks exist from previous iteration


      .. rst-class:: ansible-option-line

      :ansible-option-choices:`Choices:`

      - :ansible-option-choices-entry:`false`
      - :ansible-option-choices-entry:`true`


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_pause_pr_status_check_delay"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_pause_role__parameter-main__pr_status_check_pause_pr_status_check_delay:

      .. rst-class:: ansible-option-title

      **pr_status_check_pause_pr_status_check_delay**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_pause_pr_status_check_delay" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`integer` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Seconds to wait between status check attempts


      .. raw:: html

        </div>

  * - .. raw:: html

        <div class="ansible-option-cell">
        <div class="ansibleOptionAnchor" id="parameter-main--pr_status_check_pause_pr_status_check_retries"></div>

      .. _ansible_collections.rstyczynski.github.pr_status_check_pause_role__parameter-main__pr_status_check_pause_pr_status_check_retries:

      .. rst-class:: ansible-option-title

      **pr_status_check_pause_pr_status_check_retries**

      .. raw:: html

        <a class="ansibleOptionLink" href="#parameter-main--pr_status_check_pause_pr_status_check_retries" title="Permalink to this option"></a>

      .. ansible-option-type-line::

        :ansible-option-type:`integer` / :ansible-option-required:`required`




      .. raw:: html

        </div>

    - .. raw:: html

        <div class="ansible-option-cell">

      Maximum number of retry attempts


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
