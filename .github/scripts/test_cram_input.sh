#!/bin/bash
set -eo pipefail
export PATH=/opt/conda/bin:$PATH

echo test --cram --bed and --ref inputs >> artifacts/test_artifact.log

export REF_FILE=$(find work_singularity_profile | grep -v scheme | grep 'ref.fa$' | xargs readlink | grep ncov2019-artic-nf | head -n1 | sed s'/ncov2019-artic-nf\/work\//ncov2019-artic-nf\/work_singularity_profile\//'g)
export BED_FILE=$(find work_singularity_profile | grep -v scheme | grep 'bed$' | xargs readlink | grep ncov2019-artic-nf | head -n1 | sed s'/ncov2019-artic-nf\/work\//ncov2019-artic-nf\/work_singularity_profile\//'g)
echo ref file: $REF_FILE
echo bed file: $BED_FILE

# run current pull request code
# --sanger profile: there are only 2 available cpus in the github runner execution
sed -i s'/cpus = 4/cpus = 2/'g conf/coguk/sanger.config
singularity --version
NXF_VER=20.03.0-edge nextflow run ./main.nf \
       -profile sanger,singularity \
       --ref $REF_FILE \
       --bed $BED_FILE \
       --cram \
       --directory $PWD/.github/data/crams/ \
       --illumina \
       --prefix test
cp .nextflow.log artifacts/cram_ref_bed.nextflow.log

# check that git clone did not ran:
find work -name .command.sh \
    | xargs cat | grep 'git clone' \
    && exit 1 \
	|| echo "ran with --cram --bed and --ref: did NOT use git clone" 

echo remove files
find results results_sanger_profile \
     -name "test.qc.csv" \
     -o -name "*.fq.gz" \
     -o -name "*.bam" \
     -o -name "scheme" | xargs rm -rf
# exclude git diff renaming modifications (as the filenames of output sudbirs have an extra prefix when using --cram)
echo run git diff
git diff --no-index results results_sanger_profile | \
    grep -v 'rename to' | \
    grep -v 'rename from' | \
    grep -v 'similarity index 100%' | \
    grep -v 'diff --git' > diffs.txt || true
echo compare diffs.txt
if [ -s diffs.txt ]
then
  echo differences found for pull request with or without --cram --ref and --bed
  cp diffs.txt artifacts/diffs_cram_bed_ref.txt
  exit 1
else
  echo no differences found for pull request with or without --cram --ref and --bed 
fi

# clean-up for following tests
rm -rf results && rm -rf work && rm -rf .nextflow*
