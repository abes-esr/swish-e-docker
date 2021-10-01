# swish-e-docker

[![Docker Pulls](https://img.shields.io/docker/pulls/abesesr/swish-e-docker.svg)](https://hub.docker.com/r/abesesr/swish-e-docker/)

swish-e-docker aims to package swish-e search engine into docker (CGI and command line for indexing).

Why?

Because at [Abes](http://www.abes.fr) we uses it to search into the "Guide méthodologique du Sudoc": http://documentation.abes.fr/cgi-bin/swish.cgi
Swish-e is an old software no more maintained and our internal server (where Sudoc is hosted) needs to be upgraded. Swish-e software is no more distributed in our uptodate Linux OS (RHEL 7.7) so we have to find a way to keep using old swish-e in our uptodate OS. Docker is a good way to use a old software on an uptodate OS keeping things isolated so that the uptodate OS is not disturbed.

## Usage  

To run the web server hosting the swish-e CGI (web form):
```bash
# adjust the 8080 port where u want the web server to listen 
docker run -d --name gm-swish \
  -p 8080:80 \
  -v /var/apache2/htdocs/guide/html/.swishcgi.conf:/usr/lib/cgi-bin/.swishcgi.conf \
  abesesr/swish-e-docker:1.0.0
```
Then, the form is available at: http://127.0.0.1:8080/cgi-bin/swish.cgi

To (re-)index the HTML data located at `/var/www/html/` inside the container (`swish.conf` must point to this folder thanks to the "IndexDir" directive) :
```bash
docker run --rm -it \
  -v /var/apache2/htdocs/guide/html/:/var/www/html/
  -v /var/apache2/htdocs/guide/html/swishPourManuels.conf:/usr/lib/cgi-bin/swish.conf \
  abesesr/swish-e-docker:1.0.0 \
  swish-e -c swish.conf
```

### Configuring

You can configure swish-e CGI using these files : `.swishcgi.conf`, `swish.cgi`, `TemplateDefault.pm`
- `.swishcgi.conf` is the most common one and is used to configure swish-e CGI integrated to the web server.

You can also inject a local customized `TemplateDefault.pm` and `swish.cgi` this way:
```bash
# adjust the 8080 port where u want the web server to listen 
docker run -d --name gm-swish \
  -p 8080:80 \
  -v /var/apache2/htdocs/guide/html/.swishcgi.conf:/usr/lib/cgi-bin/.swishcgi.conf \
  -v /opt/abes-swish-e-docker/swish.cgi:/usr/lib/cgi-bin/swish.cgi \
  -v /opt/abes-swish-e-docker/TemplateDefault.pm:/usr/lib/swish-e/perl/SWISH/TemplateDefault.pm \
  abesesr/swish-e-docker:1.0.0
```

You can configure swish-e indexing script using this file : `swish.conf`
- `swish.conf` is used for indexing stuff (tells swish-e where the .html, .doc, .pdf are located for indexing)

## Developping

To develop, you have to build a first time the image (and rebuild it each time you modify Dockerfile):
```
cd image/
docker build -t mylocalswish-e:latest .
```

Then you have to create a container for the cgi (http://127.0.0.1:8080/cgi-bin/swish.cgi) or for reindexing:
```bash
# cgi
docker run --name swish-debug -d -p 8080:80 mylocalswish-e:latest

# indexing inside the above cgi container
docker exec -it swish-debug swish-e -c swish.conf
```

### Generating a new version

To generate a new version, just run theses commandes (and change the "-patch" option in the NEXT_VERSION line if necessary):
```
curl https://raw.githubusercontent.com/fmahnke/shell-semver/master/increment_version.sh > increment_version.sh
chmod +x ./increment_version.sh
CURRENT_VERSION=$(git tag | tail -1)
NEXT_VERSION=$(./increment_version.sh -patch $CURRENT_VERSION) # -patch, -minor or -major
sed -i "s#swish-e-docker:$CURRENT_VERSION#swish-e-docker:$NEXT_VERSION#g" README.md
git commit README.md -m "Version $NEXT_VERSION" 
git tag $NEXT_VERSION
git push && git push --tags
```

## See also

- https://packages.debian.org/fr/sid/swish-e
- https://manpages.debian.org/unstable/swish-e/swish.cgi.7.en.html
