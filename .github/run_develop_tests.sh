#!/bin/bash

# set up github Action artifacts
mkdir -p artifacts
echo run script run_develop_tests.sh >> artifacts/test_artifact.log
echo $PWD >> artifacts/test_artifact.log
ls -ltra >> artifacts/test_artifact.log

# install Nextflow via Conda
conda create --name nextflow
eval "$(conda shell.bash hook)"
conda activate nextflow
conda install -c bioconda nextflow

# Run the tests
echo test || exit 1

# Everything passed, exit cleanly.
exit 0
