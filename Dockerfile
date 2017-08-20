FROM multiarch/ubuntu-core:i386-xenial
MAINTAINER Sebastiano Milardo <s.milardo at hotmail.it>

ARG MININET_REPO=https://github.com/mininet/mininet.git
ARG MININET_INSTALLER=mininet/util/install.sh
ARG SDN_WISE_CONTIKI_REPO=https://github.com/sdnwiselab/sdn-wise-contiki.git
ARG SDN_WISE_JAVA_REPO=https://github.com/sdnwiselab/sdn-wise-java.git
ARG ONOS_SDN_WISE_REPO=https://github.com/sdnwiselab/onos.git

ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-i386

WORKDIR /src

# Update and install minimal
RUN apt-get update \
    && apt-get install \ 
        --yes \
        --no-install-recommends \
        --no-install-suggests \
    build-essential \
    binutils-msp430 \
    gcc-msp430 \
    msp430-libc \
    binutils-avr \
    gcc-avr \
    gdb-avr \
    avr-libc \
    avrdude \
    binutils-arm-none-eabi \
    gcc-arm-none-eabi \
    gdb-arm-none-eabi \
    openjdk-8-jdk \
    openjdk-8-jre \
    ant \
    libncurses5-dev \
    doxygen \
    srecord \
    git \
    autoconf \
    automake \
    ca-certificates \
    git \
    libtool \
    net-tools \
    openssh-client \
    patch \
    curl \
    zip \
    iputils-ping \
    unzip \

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

# SDN-WISE

# Clone and install
    && git clone --recursive $SDN_WISE_CONTIKI_REPO \
    && git clone --recursive $SDN_WISE_JAVA_REPO \
    && git clone --recursive $ONOS_SDN_WISE_REPO \

# ONOS Setup
    && export ONOS_ROOT=/src/onos \
    && tools/build/onos-buck build onos \
    && mkdir -p /src/tar \
    && cd /src/tar \
    && tar -xf /src/onos/buck-out/gen/tools/package/onos-package/onos.tar.gz --strip-components=1 \
    && rm -rf /src/onos/buck-out
    && sed -ibak '/src/onos/log4j.rootLogger=/s/$/, stdout/' $(ls -d apache-karaf-*)/etc/org.ops4j.pax.logging.cfg

# Clean up packages
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

LABEL org.label-schema.name="SDN-WISE" \
      org.label-schema.description="The stateful Software Defined Networking solution for the Internet of Things" \
      org.label-schema.url="http://sdn-wise.dieei.unict.it/" \
      org.label-schema.schema-version="1.0"

# Ports
# 6653 - OpenFlow
# 6640 - OVSDB
# 8181 - GUI
# 8101 - ONOS CLI
# 9876 - ONOS intra-cluster communication
# 9999 - SDN-WISE
EXPOSE 6653 6640 8181 8101 9876 9999

