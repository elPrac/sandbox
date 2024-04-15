FROM debian:bookworm-slim

ARG DEBCONF_NOWARNINGS="yes"
ARG DEBIAN_FRONTEND "noninteractive"
ARG DEBCONF_NONINTERACTIVE_SEEN "true"

ENV _packages \
    sed make binutils build-essential diffutils \
    iptables dnsmasq netcat-openbsd iproute2 iputils-ping

ENV _packages_broot \
    gcc g++ bash patch gzip bzip2 perl tar cpio unzip \
    rsync file bc findutils libncurses5-dev libssl-dev wget \
    git jq vim openssh-client xz-utils 

# Handle qemu if we want to run qemu within the docker container
ENV _packages_qemu\
    libbz2-dev libglib2.0-dev libgcrypt20-dev zlib1g-dev autoconf \
    automake libtool bison flex libpixman-1-dev device-tree-compiler \
    ninja-build pkg-config cmake clang libfdt-dev libelf-dev qemu-system-x86

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y ${_packages} ${_packages_broot} ${_packages_qemu}\
    && apt-get install -y --reinstall ca-certificates \
    && update-ca-certificates \
    && apt-get clean

## Clean the apt cache
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Debug installed package list
# RUN apt-mark showmanual
RUN echo 'PS1=${PS1/\\\\$/\\\\n\\\\$}' >> /etc/skel/.bashrc
RUN echo 'PROMPT_DIRTRIM=3' >> /etc/skel/.bashrc

WORKDIR /workdir/buildroot

RUN groupadd -g 1000 buildroot && \
    useradd -N -m -u 1000 -g 1000 buildroot

USER buildroot

CMD /workdir/scripts/entrypt.sh
#ENTRYPOINT ["/workdir/scripts/entrypt.sh", "bash"]

