FROM multiarch/ubuntu-core:i386-xenial

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

# Clone and install.
    && git clone --recursive $SDN_WISE_CONTIKI_REPO \
    && git clone --recursive $SDN_WISE_JAVA_REPO \
    && git clone --recursive $ONOS_SDN_WISE_REPO \

# Clean up packages.
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*