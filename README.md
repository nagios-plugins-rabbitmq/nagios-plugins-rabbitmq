nagios-plugins-rabbitmq
=======================

[![Join the chat at https://gitter.im/nagios-plugins-rabbitmq/nagios-plugins-rabbitmq](https://badges.gitter.im/nagios-plugins-rabbitmq/nagios-plugins-rabbitmq.svg)](https://gitter.im/nagios-plugins-rabbitmq/nagios-plugins-rabbitmq?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/nagios-plugins-rabbitmq/nagios-plugins-rabbitmq.svg?branch=master)](https://travis-ci.org/nagios-plugins-rabbitmq/nagios-plugins-rabbitmq)

Overview
--------
This package contains a set of nagios checks useful for monitoring a
RabbitMQ server. They use the RabbitMQ management interface with is over
HTTP and therefore have a very light profile on the nagios server.

See the [documentation](http://www.rabbitmq.com/management.html) on the
RabbitMQ management interface for more details on what it provides.

NOTE:  RabbitMQ 2.x and RabbitMQ 3.x use different ports for the management
interface. `master` is configured to use the RabbitMQ port by default (15672).
If you are running RabbitMQ 2.x, use the `rabbitmq-2.x` branch.

Branches
--------
- **master** use the perl Monitoring::plugin
- **libperl-nagios-plugin** use the perl Nagios::plugin

NOTE: The perl Nagios::plugin is now deprecated and renamed into Monitoring::plugin. It's explained [here](http://search.cpan.org/~mstrout/Nagios-Plugin-0.990001/lib/Nagios/Plugin.pm).
> Nagios::Plugin - Removed from CPAN by request of Nagios Enterprises, succeeded by Monitoring::Plugin

Status
------
Currently we have the following checks:

- check\_rabbitmq\_aliveness
  - Use the `/api/aliveness-test` API to send/receive a message.

- check\_rabbitmq\_connections
  - Use the `/api/connections` API to gather details of connections used,
    their state and their throughput

- check\_rabbitmq\_objects
  - Use a variety of APIs to count instances of various objects on the
    server. These include vhosts, exchanges, bindings, queues and
    channels.

- check\_rabbitmq\_overview
  - Use the `/api/overview` API to collect the number of pending, ready
    and unacknowledged messages on the server

- check\_rabbitmq\_partition
  - Use the `/api/nodes` API to check for partitions in a RabbitMQ cluster.

- check\_rabbitmq\_cluster
  - Use the `/api/nodes` API to check how many node are alived in the cluster.

- check\_rabbitmq\_queue
  - Use the `/api/queue` API to collect the number of pending, ready and
    unacknowledged messages and the number of consumers on a given queue

- check\_rabbitmq\_server
  - Use the `/api/nodes` API to gather resource usage of the rabbitmq server
    node

- check\_rabbitmq\_shovels
  - Use the `/api/nodes` API check that all the shovels of the given RabbitMQ
    host are running

- check\_rabbitmq\_watermark
  - Use the `/api/nodes` API to check to see if mem_alarm has been set to true

See the relevant POD documentation/man pages for more information on usage.

Licence
-------
This file is part of nagios-plugins-rabbitmq.

Copyright 2010, Platform 14.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Author
------

James Casey <jamesc.000@gmail.com>, Thierno IB. BARRY [@barryib](https://github.com/barryib)