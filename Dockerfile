FROM debian:jessie
MAINTAINER Torben Griebe <torbengriebe AT gmx DOT de>

ENV GOSU_VERSION 1.9
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get purge -y --auto-remove ca-certificates wget

RUN sed -i '/^deb/ s/$/ contrib/' /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get --no-install-recommends install -y \
		texlive \
		texlive-lang-german \
		texlive-xetex \
    && rm -rf /var/lib/apt/lists/* \
	&& groupadd -r texlive && useradd -r -g texlive texlive 

COPY docker-entrypoint.sh /

ENV LATEX_DATA /sources
VOLUME ["/sources"]
WORKDIR "/sources"

USER texlive

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["xelatex"]