#!/bin/bash

# stuff to be able to customize swish.cgi and TemplateDefault.pm
[ ! -f "/usr/lib/cgi-bin/swish.cgi" ] \
  && cp -f /usr/lib/swish-e/swish.cgi /usr/lib/cgi-bin/ \
  && sed -i "s#= '.swishcgi.conf';#= './.swishcgi.conf';#g" /usr/lib/cgi-bin/swish.cgi
chmod +x /usr/lib/cgi-bin/swish.cgi
chmod +x /usr/lib/swish-e/perl/SWISH/TemplateDefault.pm

# run CMD (see Dockerfile)
exec "$@"
