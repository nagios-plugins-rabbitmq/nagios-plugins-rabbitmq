nagios-plugins-rabbitmq
=======================

Overview
--------
This package contains a set of nagios checks useful for monitoring a
RabbitMQ server.  They use the RabbitMQ management interface with is over
HTTP and therefore have a very light profile on the nagios server.

See the [documentation](http://www.rabbitmq.com/management.html) on the
RabbitMQ management interface for more details on what it provides.

Status
------
Currently we have 5 checks:

- check\_rabbitmq\_aliveness
  - Use the `/api/aliveness-test` API to send/receive a message.

- check\_rabbitmq\_server
  - Use the `/api/nodes` API to gather resource usage of the rabbitmq server
    node

- check\_rabbitmq\_objects
  - Use a variety of APIs to count instances of various objects on the
    server.  These include vhosts, exchanges, bindings, queues and
    channels.

- check\_rabbitmq\_overview
  - Use the `/api/overview` API to collect the number of pending, ready
    and unacknowledged messages on the server

- check\_rabbitmq\_queue
  - Use the `/api/queue` API to collect the number of pending, ready
    and unacknowledged messages on a given queue

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

James Casey <jamesc.000@gmail.com>
