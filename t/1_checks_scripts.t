use Test::More 'no_plan';;
use Test::Script;
 
$rabbit_hostname        = $ENV{'RABBIT_HOSTNAME'};
$rabbit_username        = $ENV{'RABBIT_USERNAME'};
$rabbit_password        = $ENV{'RABBIT_PASSWORD'};
$rabbit_servername      = $ENV{'RABBIT_SERVERNAME'};

# Base arguments
$args = sprintf("--hostname=%s --username=%s --password=%s", $rabbit_hostname, $rabbit_username, $rabbit_password);

# Checks on check_rabbitmq_aliveness
script_runs(['scripts/check_rabbitmq_aliveness', $args]);

# Checks on check_rabbitmq_cluster
script_runs(['scripts/check_rabbitmq_cluster', ($args, ' -w 1 -c 1')]);

# Checks on check_rabbitmq_connections
script_runs(['scripts/check_rabbitmq_connections', $args]);

# Checks on check_rabbitmq_objects
script_runs(['scripts/check_rabbitmq_objects', $args]);

# Checks on check_rabbitmq_overview
script_runs(['scripts/check_rabbitmq_overview', $args]);

# Checks on check_rabbitmq_partition
script_runs(['scripts/check_rabbitmq_partition', ($args, "--node=${rabbit_servername}")]);

# Checks on check_rabbitmq_queue
script_runs(['scripts/check_rabbitmq_queue', ($args, '--queue=aliveness-test')]);

# Checks on check_rabbitmq_server
$regex = /(Memory=.*)\s(Process=.*)\s(FD=.*)/im;
script_runs(['scripts/check_rabbitmq_server', ($args, "--node=${rabbit_servername}")]);
script_stdout_like $regex, 'scripts/check_rabbitmq_server stdout is correct';

# Checks on check_rabbitmq_watermark
script_runs(['scripts/check_rabbitmq_watermark', ($args, "--node=${rabbit_servername}")]);

# Checks on check_rabbitmq_exchange
script_runs(['scripts/check_rabbitmq_exchange', ($args, '--exchange=amq.direct', '--period=60')]);