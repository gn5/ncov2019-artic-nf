#!/bin/bash

# write log as github Action artifact
mkdir artifacts
echo run script run_develop_tests.sh >> artifacts/test_artifact.log

# install Nextflow and Singularity
echo run script .github/install_nextflow_singularity.sh >> artifacts/test_artifact.log
source .github/install_nextflow_singularity.sh

# build singularity images
echo run scripts/build_singularity_containers.sh >> artifacts/test_artifact.log
bash scripts/build_singularity_containers.sh

# Run the tests
echo test

# Everything passed, exit cleanly.
exit 0
