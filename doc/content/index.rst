.. image:: ../images/otobo-logo.png
   :align: center

.. toctree::
    :maxdepth: 2
    :caption: Contents

Overview
========
Summary
-------
This package makes it possible to associate an individual config item to a group, so that only agents or customers of that group are authorized to view, search or perform operations on that config item, be it via Frontend or via web services. Any config item not associated to a group does not hold these restrictions.

Configuration
=============

System requirements
-------------------
Framework
^^^^^^^^^
OTOBO 11.0.x

Packages
^^^^^^^^
ITSMConfigurationManagement 11.0.7

Third-party software
^^^^^^^^^^^^^^^^^^^^
Not applicable

Basic Configuration
-------------------
Open the Package Manager module from the Administration group in the Agent Interface. Select the package named *ITSMConfigItemMultitenancy* from the Online Repository. Click the associated  *Install* link on that line and respond affirmatively to any confirmation questions that may follow.

If Elasticsearch is active, execute the console command *Maint::Elasticsearch::Migration --target i*

Go to *Admin->General Catalog Management->ITSM::ConfigItem::Class*, and for every config item class intended to use this feature, set the "Config Item Group" class setting (which is "Disabled" by default) as "Enabled" or "Enabled and required", depending on the field being allowed empty or not, respectively.

**Note:** Reverting the "Config Item Group" class setting back to "Disabled" does not reset the groups previously assigned to the config items of that class. The group attribute still keeps its value on the config items, although it is not visible or available anymore.

To activate the feature in the Customer module, the system configuration setting *CustomerGroupSupport* must be enabled.

Custom Configuration and Advanced Features
------------------------------------------
It is allowed to have one group whose users are exempted from any config item group restrictions. By default, this is the *admin* group, but the system configuration setting *ITSMConfigItemManagementGroup* may be used to change this privilege to a different group. If that setting is disabled, no group will have the privilege.

As mentioned above, the system configuration setting *CustomerGroupSupport* may be enabled or disabled to activate or deactivate this feature, respectively, in the Customer module.

Configuration Reference
-----------------------
Core::Elasticsearch::Settings
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Elasticsearch::ConfigItemStoreFields
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Fields stored in the configuration item index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory.

Core::Event::ITSMConfigItem
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

ITSMConfigItem::EventModulePost###100-History
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Config item event module that enables logging to history in the agent interface.

Core::GeneralCatalog
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

ITSMConfigItemManagementGroup
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Management group that exempts from any config item level group restrictions.

GeneralCatalogPreferences###ConfigitemGroup
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Mode for config item level group restrictions.

Frontend::Admin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Events###ITSMConfigItem
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
List of all Package events to be displayed in the GUI.


About
=======

Contact
-------
| Rother OSS GmbH
| Email: hello@otobo.io
| Web: https://otobo.io

Version
-------
Author: |doc-vendor| / Version: |doc-version| / Date of release: |doc-datestamp|
