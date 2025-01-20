FROM debian:bookworm-slim@sha256:f70dc8d6a8b6a06824c92471a1a258030836b26b043881358b967bf73de7c5ab

# https://imapwiki.org/ImapTest/Installation

WORKDIR /tmp

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libssl-dev \
    pkg-config \
    wget \
    && wget -P /tmp/ -c http://dovecot.org/nightly/dovecot-latest.tar.gz \
    && mkdir -p /tmp/dovecot \
    && tar -x -v -C /tmp/dovecot --strip-components=1 -f dovecot-latest.tar.gz \
    && cd /tmp/dovecot \
    && ./configure \
    && make \
    && make install \
    && cd /tmp/ && wget -P /tmp/ -c http://dovecot.org/nightly/imaptest/imaptest-latest.tar.gz \
    && tar xvf /tmp/imaptest-latest.tar.gz \
    && cd /tmp/dovecot-*-imaptest-* \
    && ./configure \
    && make \
    && make install \
    && cd / \
    && apt remove -y --purge \
    build-essential \
    cmake \
    git \
    libssl-dev \
    pkg-config \
    wget \
    && apt-get clean autoclean && apt-get autoremove -y --purge \
    && rm -rf /tmp/dovecot* /var/lib/apt/lists/* /tmp/imaptest*

WORKDIR /

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]


RUN useradd --user-group --system --create-home --no-log-init user
USER user

ENV PATH=/bin:/usr/bin:/usr/local/bin
