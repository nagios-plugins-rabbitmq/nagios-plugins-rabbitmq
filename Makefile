sources: build
	Build dist

build: 
	perl Build.pl

clean: build
	Build distclean
	@rm nagios-plugins-rabbitmq-*.tar.gz

