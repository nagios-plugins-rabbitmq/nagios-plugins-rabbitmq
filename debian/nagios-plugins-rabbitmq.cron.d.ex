#
# Regular cron jobs for the nagios-plugins-rabbitmq package
#
0 4	* * *	root	[ -x /usr/bin/nagios-plugins-rabbitmq_maintenance ] && /usr/bin/nagios-plugins-rabbitmq_maintenance
