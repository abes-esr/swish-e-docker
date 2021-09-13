FROM debian:buster

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

# apache and mod_cgi
RUN a2enmod cgi

# Config apache, CGI swish-e and TemplateDefault.pm from Abes
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./swish.cgi /usr/lib/cgi-bin/swish.cgi
COPY ./TemplateDefault.pm /usr/lib/swish-e/perl/SWISH/TemplateDefault.pm

WORKDIR /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/swish.cgi && \
	chmod +x /usr/lib/swish-e/perl/SWISH/TemplateDefault.pm
	
EXPOSE 80
CMD apachectl -D FOREGROUND