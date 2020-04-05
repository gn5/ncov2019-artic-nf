#!/bin/bash
set -eo pipefail

# write log as github Action artifact
mkdir artifacts
echo run script run_develop_tests.sh >> artifacts/test_artifact.log

# install Conda
source .github/install_conda.sh

# install Nextflow via Conda
conda install -c bioconda nextflow
NXF_VER=20.03.0-edge nextflow -version >> artifacts/test_artifact.log

# install Conda environments of the pipeline
source .github/install_conda_envs.sh

# Run the tests
echo run tests >> artifacts/test_artifact.log
NXF_VER=20.03.0-edge nextflow run main.nf \
       -profile conda \
       --directory /home/ubuntu/fastq \
       --illumina \
       --prefix test

# Everything passed, exit cleanly.
exit 0
