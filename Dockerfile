FROM debian:bookworm-slim@sha256:1537a6a1cbc4b4fd401da800ee9480207e7dc1f23560c21259f681db56768f63

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
