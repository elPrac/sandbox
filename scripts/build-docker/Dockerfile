# Use build arguments to support multiple base images and environments
ARG BASE_IMAGE
ARG BUILD_ENV=buildroot
FROM ${BASE_IMAGE}

# Use bash by default for shell logic
SHELL ["/bin/bash", "-c"]

# Set defaults and configuration
ARG BUILD_ENV
ARG DEBCONF_NOWARNINGS="yes"
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN="true"

ENV BUILD_ENV=${BUILD_ENV}
# Define packages
ENV \
  _packages="sed make binutils build-essential diffutils iptables dnsmasq netcat-openbsd iproute2 iputils-ping" \
  _packages_broot="gcc g++ bash patch gzip bzip2 perl tar cpio unzip rsync file bc findutils libncurses5-dev libssl-dev wget git jq vim openssh-client xz-utils" \
  _packages_yocto="locales chrpath diffstat texinfo python3-pip xz-utils" \
  _packages_qemu="libbz2-dev libglib2.0-dev libgcrypt20-dev zlib1g-dev autoconf automake libtool bison flex libpixman-1-dev device-tree-compiler ninja-build pkg-config cmake clang libfdt-dev libelf-dev qemu-system-x86"

USER root
  # Install all packages in one efficient layer
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y ${_packages} ${_packages_qemu} && \
    if [ "$BUILD_ENV" == "buildroot" ]; then \
        apt-get install -y ${_packages_broot}; \
    elif [ "$BUILD_ENV" == "yocto" ]; then \
        apt-get install -y ${_packages_yocto}; \
    else \
        echo "Unknown environment: $BUILD_ENV" && exit 1; \
    fi && \
    apt-get install -y --reinstall ca-certificates && \
    update-ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Prepare user environment
RUN echo 'PS1=${PS1/\\\\$/\\\\n\\\\$}' >> /etc/skel/.bashrc && \
    echo 'PROMPT_DIRTRIM=3' >> /etc/skel/.bashrc

#RUN locale-gen en_US.UTF-8
#
## Set environment variables for the locale
#ENV LANG en_US.UTF-8
#ENV LC_ALL en_US.UTF-8

# Set up workspace and user
#WORKDIR /workdir/sandbox

#RUN groupadd -g 1000 sandbox && \
#    useradd -N -m -u 1000 -g 1000 sandbox

# Switch to non-root user
# USER sandbox

# Use CMD array form (better signal handling)
CMD ["/workdir/scripts/entrypt.sh"]
