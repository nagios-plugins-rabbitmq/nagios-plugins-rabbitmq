sources: build
	Build dist

build: 
	perl Build.pl

clean: build
	Build distclean
	@rm -f nagios-plugins-rabbitmq-*.tar.gz RabbitMQ-API-*.tar.gz

