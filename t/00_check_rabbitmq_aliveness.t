use Test::More 'no_plan';;
use Test::Script;
 
$rabbit_hostname =  $ENV{'RABBIT_HOSTNAME'};
$rabbit_username =  $ENV{'RABBIT_USERNAME'};
$rabbit_password =  $ENV{'RABBIT_PASSWORD'};
$rabbit_vhost =  $ENV{'RABBIT_VHOST'};

script_compiles('scripts/check_rabbitmq_aliveness', 'Check aliveness compilation');

$args = sprintf("--hostname=%s --username=%s --password=%s --vhost=%s", $rabbit_hostname, $rabbit_username, $rabbit_password, $rabbit_vhost);
script_runs(['scripts/check_rabbitmq_aliveness', $args], 'Check aliveness with correct credentials');