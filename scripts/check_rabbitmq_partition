#!/usr/bin/env perl

###  check_rabbitmq_partition

# Use the management API to check if partitions error conditions exist.

# baseed on check_rabbitmq_watermark.pl,
# Originally by Nathan Vonnahme, n8v at users dot sourceforge
# dot net, July 19 2006

##############################################################################
# prologue
use strict;
use warnings;

use Monitoring::Plugin;
use LWP::UserAgent;
use URI::Escape;
use JSON;

use vars qw($VERSION $PROGNAME  $verbose $timeout);
$VERSION = '2.0.3';

# get the base name of this script for use in the examples
use File::Basename;
$PROGNAME = basename($0);


##############################################################################
# define and get the command line options.
#   see the command line option guidelines at
#   http://nagiosplug.sourceforge.net/developer-guidelines.html#PLUGOPTIONS


# Instantiate Monitoring::Plugin object (the 'usage' parameter is mandatory)
my $p = Monitoring::Plugin->new(
    usage => "Usage: %s [options] -H hostname",
    license => "",
    version => $VERSION,
    blurb => 'This plugin uses the RabbitMQ management API to check if the mem_alarm has been triggered',
);

$p->add_arg(spec => 'hostname|host|H=s',
    help => "Specify the host to connect to",
    required => 1
);
$p->add_arg(spec => 'port=i',
    help => "Specify the port to connect to (default: %s)",
    default => 15672
);
$p->add_arg(spec => 'node|n=s',
    help => "Specify the node name (default is hostname)"
);
$p->add_arg(spec => 'username|user|u=s',
    help => "Username (default: %s)",
    default => "guest",
);
$p->add_arg(spec => 'password|p=s',
    help => "Password (default: %s)",
    default => "guest"
);

$p->add_arg(spec => 'ssl|ssl!',
    help => "Use SSL (default: false)",
    default => 0
);

$p->add_arg(spec => 'ssl_strict|ssl_strict!',
    help => "Verify SSL certificate (default: true)",
    default => 1
);

$p->add_arg(spec => 'proxy|proxy!',
    help => "Use environment proxy (default: true)",
    default => 1
);
$p->add_arg(spec => 'proxyurl=s',
    help => "Use proxy url like http://proxy.domain.com:8080",
);

$p->add_arg(spec => 'rname|r=s',
    help => "RabbitName (default: %s)",
    default => "rabbit",
);

# Parse arguments and process standard ones (e.g. usage, help, version)
$p->getopts;


# perform sanity checking on command line options


##############################################################################
# check stuff.

my $hostname=$p->opts->hostname;
my $port=$p->opts->port;

my $nodename = $p->opts->node;

my $rname = $p->opts->rname;

if (!$nodename) {
    $hostname =~ /^([a-zA-Z0-9-.]+)/;
    $nodename = $1;
}

my $url = sprintf("http%s://%s:%d/api/nodes/%s\@%s", ($p->opts->ssl ? "s" : ""), $hostname, $port, $rname, $nodename);
my $ua = LWP::UserAgent->new;
if (defined $p->opts->proxyurl)
{
    $ua->proxy('http', $p->opts->proxyurl);
}
elsif($p->opts->proxy == 1 )
{
    $ua->env_proxy;
}
$ua->agent($PROGNAME.' ');
$ua->timeout($p->opts->timeout);
if ($p->opts->ssl and $ua->can('ssl_opts')) {
    $ua->ssl_opts(verify_hostname => $p->opts->ssl_strict);
}

my $req = HTTP::Request->new(GET => $url);
$req->authorization_basic($p->opts->username, $p->opts->password);
my $res = $ua->request($req);

if (!$res->is_success) {
    # Deal with standard error conditions - make the messages more sensible
    if ($res->code == 400) {
        my $bodyref = decode_json $res->content;
        $p->nagios_exit(CRITICAL, $bodyref->{'reason'});
    }
    $res->code == 404 and $p->nagios_die("Not found");
    $res->code == 401 and $p->nagios_die("Access refused");
    if ($res->code < 200 or $res->code > 400 ) {
        $p->nagios_exit(CRITICAL, "Received ".$res->status_line);
    }
}
my $bodyref = decode_json $res->content;

my $partitions=$bodyref->{'partitions'};
ref($partitions) eq "ARRAY" or $p->nagios_exit(CRITICAL, $res->content);
scalar(@$partitions)==0 or $p->nagios_exit(CRITICAL, "Partitions detected: @$partitions");

my($code, $message) = (OK, "No Partitions");
$p->nagios_exit(
    return_code => $code,
    message => $message
);

=head1 NAME

check_rabbitmq_partition - Nagios plugin using RabbitMQ management API to check if a cluster partition has occured

=head1 SYNOPSIS

check_rabbitmq_partition [options] -H hostname

=head1 DESCRIPTION

Use the management interface of RabbitMQ to check if a cluster partition has occured.

It uses Monitoring::Plugin and accepts all standard Nagios options.

=head1 OPTIONS

=over

=item -h | --help

Display help text

=item -v | --verbose

Verbose output

=item -t | --timeout

Set a timeout for the check in seconds

=item -H | --hostname | --host

The host to connect to

=item --port

The port to connect to (default: 15672)

=item --ssl

Use SSL when connecting (default: false)

=item -n | --node

The node name (default is hostname)

=item -r | --rname

The rabbit name (default is rabbit)

=item --username | --user

The user to connect as (default: guest)

=item -p | --password

The password for the user (default: guest)

=back

=head1 EXAMPLES

The defaults all work with a standard fresh install of RabbitMQ, and all that
is needed is to specify the host to connect to:

    check_rabbitmq_node -H rabbit.example.com

This returns a standard Nagios result:

    RABBITMQ_NODE OK - No Partitions

=head1 ERRORS

The check tries to provide useful error messages on the status line for
standard error conditions.

Otherwise it returns the HTTP Error message returned by the management
interface.

=head1 EXIT STATUS

Returns zero if check is OK otherwise returns standard Nagios exit codes to
signify WARNING, UNKNOWN or CRITICAL state.

=head1 SEE ALSO

See Monitoring::Plugin(3)

The RabbitMQ management plugin is described at
http://www.rabbitmq.com/management.html

=head1 LICENSE

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

=head1 AUTHOR

James Casey <jamesc.000@gmail.com>

=cut

1;
