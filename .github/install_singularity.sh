#!/bin/bash
set -eo pipefail

export PATH=/usr/local/go/bin:$PATH
echo $(which go)
go -version

# install Singularity
export VERSION=3.5.3
wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz
tar -xzf singularity-${VERSION}.tar.gz
cd singularity
./mconfig
make -C builddir
sudo make -C builddir install
cd ..
echo $(which singularity)
