#!/bin/bash
set -eo pipefail

# write log as github Action artifact
mkdir artifacts
echo run tests >> artifacts/test_artifact.log

export PATH=/opt/conda/bin:$PATH
ls -ltra
singularity --version
NXF_VER=20.03.0-edge nextflow run ./main.nf \
       -profile singularity \
       --directory ./test_data/fastq \
       --illumina \
       --prefix test

# test conda profile
# install Conda environments of the pipeline
#source .github/install_conda_envs.sh
# Run the tests
#echo run tests >> artifacts/test_artifact.log
#NXF_VER=20.03.0-edge nextflow run main.nf \
#       -profile conda \
#       --directory test_data/fastq \
#       --illumina \
#       --prefix test
