#!/usr/bin/env bash

set -exuo pipefail

if [ ! -z "$TRAVIS_PULL_REQUEST" ] && [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "Skipping publishing in a Pull Request"
  exit 0
fi

if [ ! -z "$TRAVIS_TEST_RESULT" ] && [ "$TRAVIS_TEST_RESULT" != "0" ]; then
  echo "Build has failed, skipping publishing"
  exit 0
fi

if [ -z "$ARTIFACTS_DIR"]; then
  echo "Error: Environment varialbe ARTIFACTS_DIR is not set."
  exit 1
fi

cd .travis/tools
pip install -r ci_release_publisher/requirements.txt
python -m ci_release_publisher publish --help
python -m ci_release_publisher publish --latest-release \
                                       --latest-release-prerelease \
                                       --numbered-release \
                                       --numbered-release-keep-count 3 \
                                       --numbered-release-prerelease \
                                       --tag-release \
                                       "$ARTIFACTS_DIR"
