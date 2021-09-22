# swish-e-docker

[![Docker Pulls](https://img.shields.io/docker/pulls/abesesr/swish-e-docker.svg)](https://hub.docker.com/r/abesesr/swish-e-docker/)

swish-e-docker aims to package swish-e search engine into docker (CGI and command line for indexing).

Why?

Because at [Abes](http://www.abes.fr) we uses it to search into the "Guide méthodologique du Sudoc": http://documentation.abes.fr/cgi-bin/swish.cgi
Swish-e is an old software no more maintained and our internal server (where Sudoc is hosted) needs to be upgraded. Swish-e software is no more distributed in our uptodate Linux OS (RHEL 7.7) so we have to find a way to keep using old swish-e in our uptodate OS. Docker is a good way to use a old software on an uptodate OS keeping things isolated so that the uptodate OS is not disturbed.

WARNING: work in progress

## Usage  

To run the web server hosting the swish-e CGI (web form):
```bash
# adjust the 8080 port where u want the web server to listen 
docker run -d --name gm-swish \
  -p 8080:80 \
  -v /var/apache2/htdocs/guide/html/.swishcgi.conf:/usr/lib/cgi-bin/.swishcgi.conf \
  abesesr/swish-e-docker:1.0.1
```
Then, the form is available at: http://127.0.0.1:8080/cgi-bin/swish.cgi

To (re-)index the HTML data (mounted at `/var/www/html/`) :
```bash
docker run --rm -it \
  -v /var/apache2/htdocs/guide/html/:/var/www/html/
  -v /var/apache2/htdocs/guide/html/swishPourManuels.conf:/usr/lib/cgi-bin/swish.conf \
  abesesr/swish-e-docker:1.0.1 \
  swish-e -c swish.conf
```

### Configuring

You can configure swish-e using these two files : `swish.conf` and `.swishcgi.conf`

- `swish.conf` is used to tell swish-e where the HTML are located for indexing.
- `.swishcgi.conf` is used to configure swish-e CGI integrated to the web server.

## Developping

To develop, you have to build a first time the image (and rebuild it each time you modify Dockerfile):
```
docker build -t mylocalswish-e:latest .
```

Then you have to create a container for the cgi (http://127.0.0.1:8080/cgi-bin/swish.cgi) or for reindexing:
```bash
# cgi
docker run --rm -p 8080:80 \
  -v $(pwd)/.swishcgi.conf:/usr/lib/cgi-bin/.swishcgi.conf \
  mylocalswish-e:latest
# indexing
docker run --rm \
  -v $(pwd)/swish.conf:/usr/lib/cgi-bin/swish.conf \
  mylocalswish-e:latest \
  swish-e -c swish.conf
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
