FROM multiarch/ubuntu-core:i386-xenial
MAINTAINER Sebastiano Milardo <s.milardo at hotmail.it>

ARG MININET_REPO=https://github.com/mininet/mininet.git
ARG MININET_INSTALLER=mininet/util/install.sh

ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-i386
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /tmp

# Update and install minimal.
RUN \
    apt-get update \
        --quiet \
    && apt-get install \
        --yes \
        --no-install-recommends \
        --no-install-suggests \
    autoconf \
    automake \
    ca-certificates \
    git \
    libtool \
    net-tools \
    openssh-client \
    patch \
    iputils-ping \
    
# Mininet

    && git clone --recursive $MININET_REPO \
    && sed \
      -e 's/sudo //g' \
      -e 's/DEBIAN_FRONTEND=noninteractive //g' \
      -e 's/~\//\//g' \
      -i $MININET_INSTALLER \
    && touch /.bashrc \
    && chmod +x $MININET_INSTALLER \
    && ./$MININET_INSTALLER -nfv \
    && rm -rf /src/mininet \
              /src/openflow \

# Clean up source.
    && rm -rf /tmp/mininet \
              /tmp/openflow \

# Clean up packages.
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \

# Clean up packages
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

VOLUME ["/data"]

WORKDIR /data

# Default command.
CMD ["bash"]