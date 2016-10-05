FROM ubuntu:xenial
MAINTAINER Merlijn Tishauser <merlijn@gargleblaster.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq -y && \
    apt-get install -yq --no-install-recommends \
	lsb-release \
	bash \
	apache2 && \
	apt-get clean &&\
	rm -rf /var/lib/apt/lists/*

VOLUME ["/etc/apache2"]

EXPOSE 80 443

CMD ["apachectl", "-D", "FOREGROUND"]

