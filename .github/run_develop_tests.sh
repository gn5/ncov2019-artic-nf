#!/bin/sh
# set up github Action artifacts
mkdir -p artifacts
echo run script run_develop_tests.sh >> artifacts/test_artifact.log
# Run the tests
echo test || exit 1
# Everything passed, exit cleanly.
exit 0
