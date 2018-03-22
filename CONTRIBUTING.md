Contributing to nagios-plugins-rabbitmq
=======================================

The Nagios plugins for RabbitMQ are written and maintained by the community, according to the following contribution guidelines.

Repository structure
--------------------

-	**master** - Default and development branch which uses `Monitoring::plugin` . All pull request are merged into this branch and are tested before any merging or backporting to other branches occurs
-	**libperl-monitoring-plugin** - Stable branch which uses the perl `Monitoring::plugin`
-	**libperl-nagios-plugin** - Stable branch which uses the perl `Nagios::plugin`

NOTE: Please Make sure you get the latest **master** branch before any contributions.

Contributing code to an existing script
---------------------------------------

Fork the project on GitHub.

Making use of your new copy, pull the latest master branch and edit the code.

Commit your changes and create a pull request from the original repository.

Contributing code to a new script
---------------------------------

Fork the project on GitHub.

Making use of your new copy, pull the latest master branch and create your new script.

Commit your changes and create a pull request from the original repository.

Tests are not mandatory for a pull request for new scripts however they are very much appreciated and encouraged.

NOTE: New scripts should be tested by travis before being added to stable branches.

Question?
---------

Please use the [nagios-plugins-rabbitmq's gitter channels](https://gitter.im/orgs/nagios-plugins-rabbitmq/rooms) to ask a question to the community.

The Github issue tracker is not the best place for questions for various reasons, but [gitter channels](https://gitter.im/orgs/nagios-plugins-rabbitmq/rooms) are very helpful.
