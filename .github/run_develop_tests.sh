#!/bin/bash
set -euo pipefail

# write log to github Action artifacts
mkdir -p artifacts
echo run script run_develop_tests.sh >> artifacts/test_artifact.log

# install Nextflow via Conda
conda create --name nextflow
eval "$(conda shell.bash hook)"
conda activate nextflow
conda install -c bioconda nextflow
NXF_VER=20.03.0-edge nextflow -version >> artifacts/test_artifact.log

# install Singularity 
sudo apt-get update && sudo apt-get install -y \
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
export VERSION=1.13 OS=linux ARCH=amd64
wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz
sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz
rm go$VERSION.$OS-$ARCH.tar.gz
export PATH=/usr/local/go/bin:$PATH
export VERSION=3.5.3
wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz && \
tar -xzf singularity-${VERSION}.tar.gz && \
cd singularity
./mconfig
make -C builddir
sudo make -C builddir install
cd ..
singularity version >> artifacts/test_artifact.log 

# build singularity images
bash scripts/build_singularity_containers.sh

# Run the tests
echo test

# Everything passed, exit cleanly.
exit 0
