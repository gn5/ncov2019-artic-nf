#!/bin/bash
set -eo pipefail

# write log as github Action artifact
mkdir artifacts
echo run tests >> artifacts/test_artifact.log

export PATH=/opt/conda/bin:$PATH
ls -ltra

# run current pull request code
singularity --version
NXF_VER=20.03.0-edge nextflow run ./main.nf \
       -profile singularity \
       --directory $PWD/.github/data/ \
       --illumina \
       --prefix test

# run upstream connor-lab fork
git clone https://github.com/connor-lab/ncov2019-artic-nf.git upstream_fork
cd upstream_fork
ln -s ../*.sif ./
NXF_VER=20.03.0-edge nextflow run ./main.nf \
       -profile singularity \
       --directory $PWD/../.github/data/ \
       --illumina \
       --prefix test
cd ..

# exclude files from comparison
# and list differences
find results ./upstream_fork/results \
     -name "test.qc.csv" \
     -o -name "*.fq.gz" \
     -o -name "scheme" | xargs rm -rf
git diff --stat --no-index results ./upstream_fork/results > diffs.txt
if [ -s diffs.txt ]
then
  echo no differences         
else
  echo differences found       
  cp diffs.txt artifacts/  
  exit 1
fi



# test conda profile
# install Conda environments of the pipeline
#source .github/scripts/install_conda_envs.sh
# Run the tests
#echo run tests >> artifacts/test_artifact.log
#NXF_VER=20.03.0-edge nextflow run main.nf \
#       -profile conda \
#       --directory test_data/fastq \
#       --illumina \
#       --prefix test