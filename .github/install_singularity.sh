#!/bin/bash
set -eo pipefail

# install Singularity dependencies 
sudo apt-get update
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    squashfs-tools \
    libseccomp-dev \
    wget \
    pkg-config \
    git \
    cryptsetup

# install Go compiler
export VERSION=1.13 OS=linux ARCH=amd64
wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz
rm go$VERSION.$OS-$ARCH.tar.gz
export PATH=/usr/local/go/bin:$PATH
echo $(which go)

# install Singularity
export VERSION=3.5.3
wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz
tar -xzf singularity-${VERSION}.tar.gz
cd singularity
./mconfig
sudo make -C builddir
sudo make -C builddir install
cd ..
echo $(which singularity)
