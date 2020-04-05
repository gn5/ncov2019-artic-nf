#!/bin/bash
set -eo pipefail

# write log as github Action artifact
mkdir artifacts
echo run script run_develop_tests.sh >> artifacts/test_artifact.log

# install Conda
bash .github/install_conda.sh

# install Nextflow via Conda
export PATH=/opt/conda/bin:$PATH
conda install -c bioconda nextflow

# test singularity profile
sed -i s'/sudo //'g .github/install_singularity.sh
bash .github/install_singularity.sh
echo run tests >> artifacts/test_artifact.log
NXF_VER=20.03.0-edge nextflow run main.nf \
       -profile singularity \
       --directory test_data/fastq \
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

# Everything passed, exit cleanly.
exit 0
