use Test::More 'no_plan';;
use Test::Script;
 

script_compiles('scripts/check_rabbitmq_aliveness');
script_compiles('scripts/check_rabbitmq_cluster');
script_compiles('scripts/check_rabbitmq_connections');
script_compiles('scripts/check_rabbitmq_objects');
script_compiles('scripts/check_rabbitmq_overview');
script_compiles('scripts/check_rabbitmq_partition');
script_compiles('scripts/check_rabbitmq_shovels');
script_compiles('scripts/check_rabbitmq_server');
script_compiles('scripts/check_rabbitmq_queue');
script_compiles('scripts/check_rabbitmq_watermark');