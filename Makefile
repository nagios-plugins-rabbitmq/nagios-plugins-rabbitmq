sources: build
	./Build dist

build: 
	perl Build.PL

clean: build
	./Build distclean
	@rm -f nagios-plugins-rabbitmq-*.tar.gz RabbitMQ-API-*.tar.gz _build
	$(RM) META.json META.yml

