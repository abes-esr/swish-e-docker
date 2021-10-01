FROM debian:buster

# libdate-calc-perl : for .xslx .calc parsing/indexing
# catdoc : for .doc parsing/indexing
# wc : for .doc parsing/indexing
# xpdf-utils : for .pdf parsing/indexing
RUN apt-get update && \
	apt-get install -y \
	swish-e \
	libwww-perl \
	libhtml-parser-perl \
	xpdf-utils \
	catdoc \
	libdate-calc-perl \
	wv \
	apache2 \
	libcgi-session-perl \
	vim


# Default config file for swish-e
COPY ./.swishcgi.conf /usr/lib/cgi-bin/.swishcgi.conf
COPY ./swish.conf     /usr/lib/cgi-bin/swish.conf


# Config apache for CGI swish-e
WORKDIR /usr/lib/cgi-bin/
RUN a2enmod cgi
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf
EXPOSE 80

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apachectl", "-DFOREGROUND"]
