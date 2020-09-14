FROM debian:buster

RUN apt update && \
    apt-get install -y swish-e libwww-perl libhtml-parser-perl && \
    apt-get install -y apache2 libcgi-session-perl

# apache and mod_cgi
RUN a2enmod cgi
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf
WORKDIR /usr/lib/cgi-bin/

# config CGI of swish-e
RUN cp -f /usr/lib/swish-e/swish.cgi /usr/lib/cgi-bin/ && \
    chmod +x /usr/lib/cgi-bin/swish.cgi && \
    sed -i "s#= '.swishcgi.conf';#= './.swishcgi.conf';#g" /usr/lib/cgi-bin/swish.cgi
COPY ./.swishcgi.conf /usr/lib/cgi-bin/

# create a first swish-e index
# (sample because only /var/www/html/index.html is available) 
COPY ./swish.conf /usr/lib/cgi-bin/
RUN swish-e -c swish.conf

EXPOSE 80
CMD apachectl -D FOREGROUND