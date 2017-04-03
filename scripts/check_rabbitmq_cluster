#!/usr/bin/env perl
#
# check_rabbitmq_cluster
#
# Use the management API to check how many node are alive in the cluster.

use strict;
use warnings;

use Monitoring::Plugin qw(OK CRITICAL WARNING UNKNOWN);
use Monitoring::Plugin::Functions qw(%STATUS_TEXT);
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
    blurb => 'This plugin uses the RabbitMQ management API to check how many node are in the cluster',
);

$p->add_arg(spec => 'hostname|host|H=s',
    help => "Specify the host to connect to",
    required => 1
);

$p->add_arg(spec => 'port=i',
    help => "Specify the port to connect to (default: %s)",
    default => 15672
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

$p->add_arg(spec => 'nodes|n=s',
    help => "Comma separated list of expected nodes in the cluster",
);

$p->add_arg(
    spec => 'warning|w=s',
    help =>
qq{-w, --warning=THRESHOLD[,THRESHOLD[,THRESHOLD]]
   Warning thresholds specified in order that the metrics are returned.
   Specify -1 if no warning threshold.},

);

$p->add_arg(
    spec => 'critical|c=s',
    help =>
qq{-c, --critical=THRESHOLD[,THRESHOLD[,THRESHOLD]]
   Critical thresholds specified in order that the metrics are returned.
   Specify -1 if no critical threshold.},
);

# Parse arguments and process standard ones (e.g. usage, help, version)
$p->getopts;

# perform sanity checking on command line options
my %warning;
if (defined $p->opts->warning) {
    my @warning = split(',', $p->opts->warning);
    $p->nagios_die("You should specify 1 to 3 ranges for --warning argument") unless $#warning < 3;

    $warning{'nb_running_node'} = shift @warning;
    $warning{'nb_running_disc_node'} = shift @warning;
    $warning{'nb_running_ram_node'} = shift @warning;
}

my %critical;
if (defined $p->opts->critical) {
    my @critical = split(',', $p->opts->critical);
    $p->nagios_die("You should specify specify 1 to 3 ranges for --critical argument") unless $#critical < 3;

    $critical{'nb_running_node'} = shift @critical;
    $critical{'nb_running_disc_node'} = shift @critical;
    $critical{'nb_running_ram_node'} = shift @critical;
}

# check stuff.
my $hostname=$p->opts->hostname;
my $port=$p->opts->port;

my $url = sprintf("http%s://%s:%d/api/nodes", ($p->opts->ssl ? "s" : ""), $hostname, $port);
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

my ($retcode, $result) = request($url);
if ($retcode != 200) {
    $p->nagios_exit(CRITICAL, "$result : $url");
}

my $values = {};
$values->{'running_nodes'} = ();
$values->{'nb_running_node'} = 0;
$values->{'nb_running_disc_node'} = 0;
$values->{'nb_running_ram_node'} = 0;

foreach my $node ( @$result ) {
    if ($node->{"name"} && $node->{"running"}) {
        push @{ $values->{'running_nodes'} }, $node->{"name"};

        $values->{'nb_running_node'}++;
        $values->{'nb_running_disc_node'}++ if ($node->{"type"} && $node->{"type"} eq "disc");
        $values->{'nb_running_ram_node'}++ if ($node->{"type"} && $node->{"type"} eq "ram");
    }
}

my $code = 0;
my $message = "";

if (defined($p->opts->nodes)) {
    my @nodes = split(',', $p->opts->nodes);
    my @excluded_nodes = diff(\@nodes, \@{ $values->{'running_nodes'} });
    my $nb_excluded_nodes = @excluded_nodes;
    ($code, $message) = (OK, "All nodes are running");
    ($code, $message) = (CRITICAL, "$nb_excluded_nodes failed cluster node: " . join(',', @excluded_nodes)) if($nb_excluded_nodes ne 0);
}
else {
    my @metrics = ("nb_running_node", "nb_running_disc_node", "nb_running_ram_node");
    for my $metric (@metrics) {
        my $warning = undef;
        $warning = $warning{$metric} if (defined $warning{$metric} and $warning{$metric} ne -1);
        
        my $critical = undef;
        $critical = $critical{$metric} if (defined $critical{$metric} and $critical{$metric} ne -1);

        my $value = 0;
        $value = $values->{$metric} if defined $values->{$metric};
        my $code = $p->check_threshold(check => $value, warning => $warning, critical=> $critical);
        $p->add_message($code, sprintf("$metric ".$STATUS_TEXT{$code}." (%d)", $value));
    }
    ($code, $message) = $p->check_messages(join_all=>', ');
}

$p->nagios_exit(return_code => $code, message => $message);

sub request {
    my ($url) = @_;
    my $req = HTTP::Request->new(GET => $url);
    $req->authorization_basic($p->opts->username, $p->opts->password);
    my $res = $ua->request($req);

    if (!$res->is_success) {
        # Deal with standard error conditions - make the messages more sensible
        if ($res->code == 400) {
            my $bodyref = decode_json $res->content;
            return (400, $bodyref->{'reason'});

        }
        $res->code == 404 and return (404, "Not Found");
        $res->code == 401 and return (401, "Access Refused");
        $res->status_line =~ /Can\'t connect/ and return (500, "Connection Refused : $url");
        if ($res->code < 200 or $res->code > 400 ) {
            return ($res->code, "Received ".$res->status_line);
        }
    }
    my $bodyref = decode_json $res->content;
    return($res->code, $bodyref);
}

sub diff {
    my ($array_1, $array_2) = (@_);
    return grep { my $baz = $_; !grep{$_ eq $baz} @$array_2; } @$array_1;
}

=head1 NAME

check_rabbitmq_cluster - Nagios plugin using RabbitMQ management API to check how many node are alive in the cluster

=head1 SYNOPSIS

check_rabbitmq_cluster [options] -H hostname

=head1 DESCRIPTION

Use the `/api/nodes` API to check how many node are alive in the cluster.

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

=item --username | --user

The user to connect as (default: guest)

=item -p | --password

The password for the user (default: guest)

=back

=head1 EXAMPLES

The defaults all work with a standard fresh install of RabbitMQ, and all that
is needed is to specify the host to connect to:

    check_rabbitmq_cluster -H rabbit.example.com

This returns a standard Nagios result:

    RABBITMQ_CLUSTER OK - The cluster has 3 nodes

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

Thierno IB. BARRY

=cut

1;
