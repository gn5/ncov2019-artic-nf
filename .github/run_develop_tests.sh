#!/bin/bash
set -eo pipefail

# write log as github Action artifact
mkdir artifacts
echo run script run_develop_tests.sh >> artifacts/test_artifact.log

# install Nextflow and Singularity
echo run script .github/install_nextflow_singularity.sh >> artifacts/test_artifact.log
source .github/install_nextflow_singularity.sh

# install Conda envs
source .github/install_conda_envs.sh

# build singularity images
#apt-get install uidmap
#sed -i s'/sudo singularity build /singularity build --fakeroot /'g \
#    scripts/build_singularity_containers.sh
#echo run scripts/build_singularity_containers.sh >> artifacts/test_artifact.log
#bash scripts/build_singularity_containers.sh

# Run the tests
echo run tests
#NXF_VER=20.03.0-edge nextflow run main.nf \
#       -profile singularity \
#       --directory /home/ubuntu/fastq \
#       --illumina \
#       --prefix test

# Everything passed, exit cleanly.
exit 0
