# Firefly development environment based on Ubuntu 16.04 LTS.

# Start with Ubuntu 22.04 LTS.
FROM ubuntu:22.04

MAINTAINER briq <990647625@qq.com>

# Required dependencies
ENV KERNEL_BUILDDEPS="git-core gnupg flex bison gperf build-essential zip curl \
        zlib1g-dev gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf libc6-dev libncurses5-dev \
        x11proto-core-dev libx11-dev ccache libgl1-mesa-dev \
        libxml2-utils xsltproc gawk unzip device-tree-compiler" \
    BUILDROOT_BUILDDEPS="libfile-which-perl sed make binutils gcc g++ bash \
        patch gzip bzip2 perl tar cpio python3 unzip rsync file bc libmpc3 \
        git repo texinfo pkg-config cmake tree python3" \
    TOOLS="genext2fs time wget liblz4-tool vim" \
    PROJECT="/home/studio"

# Update repository of Alibaba
# COPY sources.list /etc/apt/sources.list

# ENTRYPOINT
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY sources.list /etc/apt/sources.list

# Default workdir
WORKDIR $PROJECT

# Update package lists
RUN sed -i 's/https:/http:/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y install ca-certificates \
    && sed -i 's/http:/https:/g' /etc/apt/sources.list \
    && apt-get upgrade -y \
# Install gosu
    && apt-get -y install curl \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.11/gosu-$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
# Install dependencies
    && apt-get install -y $KERNEL_BUILDDEPS \
    && apt-get install -y $BUILDROOT_BUILDDEPS \
    && apt-get install -y $TOOLS \
# Clean
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
# Change the access permissions of entrypoint.sh
    && chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD [ "/bin/bash" ]
