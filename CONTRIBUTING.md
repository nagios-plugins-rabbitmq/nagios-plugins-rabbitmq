Contributing to nagios-plugins-rabbitmq
=======================================

The Nagios plugins for RabbitMQ are written and maintained by the community, according to the following contribution guidelines.

If you'd like to know the repository structure
----------------------------------------------

This repository is structured as follow:

- **master** - Default and development branch which use ``Monitoring::plugin`` . All pull request are merged on this branch and tested before any merging or backporting to other branches
- **libperl-monitoring-plugin** - Stable branche which use the perl ``Monitoring::plugin``
- **libperl-nagios-plugin** - Stable branche which  use the perl ``Nagios::plugin``

NOTE:  Make sure you get the latest **devel** branch before any contributions.

If you'd like to contribute code to an existing script
------------------------------------------------------

Get the latest devel branch, code your stuff and make a PR.

If you'd like to contribute code to a new script
------------------------------------------------

Get the latest devel branch, code your stuff and make a PR.

Tests are not mandatory for a PR for new scripts, but are very appreciated.

NOTE:  New scripts should be tested by travis before to be added to stable branches.

If you'd like to ask a question
-------------------------------

Please use the [nagios-plugins-rabbitmq's gitter channels](https://gitter.im/orgs/nagios-plugins-rabbitmq/rooms) to ask a question to the community.

The Github issue tracker is not the best place for questions for various reasons, but [gitter channels](https://gitter.im/orgs/nagios-plugins-rabbitmq/rooms) are very helpful.