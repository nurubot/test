#!/usr/bin/env bash

set -exuo pipefail

if [ ! -z "$TRAVIS_TEST_RESULT" ] && [ "$TRAVIS_TEST_RESULT" != "0" ]; then
  echo "Build has failed, skipping publishing"
  exit 0
fi

if [ ! -z "$TRAVIS_PULL_REQUEST" ] && [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "Skipping publishing in a Pull Request"
  exit 0
fi

cd .travis/tools
pip install -r ci_release_publisher/requirements.txt
export ARTIFACTS_DIR="$(mktemp -d)"
python -m ci_release_publisher --help
python -m ci_release_publisher collect --help
python -m ci_release_publisher collect "$ARTIFACTS_DIR"