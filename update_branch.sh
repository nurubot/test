#!/usr/bin/env bash

set -euo pipefail


# Put away our travis config for now
cp .travis.${DIFFERENT_REPO_BRANCH}.yml ..

# Checkout main repository's branch
git remote rm origin
git remote add origin https://$GITHUB_ACCESS_TOKEN@github.com/$TRAVIS_REPO_SLUG > /dev/null 2>&1
git remote add upstream https://github.com/$MAIN_REPO_SLUG > /dev/null 2>&1
git fetch upstream > /dev/null 2>&1
git branch -D $DIFFERENT_REPO_BRANCH || true
git checkout -b $DIFFERENT_REPO_BRANCH upstream/$MAIN_REPO_BRANCH

# Don't create a new release if the main repository hasn't updated since the previous release
if [ -f "/tmp/cirp/previous_runs_commit" ]; then
  if [ "$(cat /tmp/cirp/previous_runs_commit)" == "$(git rev-parse HEAD)" ]; then
    echo "The main repository hasn't been updated since the last release"
    exit 0
  else
    git rev-parse HEAD > /tmp/cirp/previous_runs_commit
  fi
else
  mkdir -p /tmp/cirp
  git rev-parse HEAD > /tmp/cirp/previous_runs_commit
fi

# Patch up the main repo's Travis-CI configuration so that it creates releases
mv ../.travis.${DIFFERENT_REPO_BRANCH}.yml .travis.yml
sed -i 's/-m ci_release_publisher/-m ci_release_publisher --travis-instance-com/' .travis/ci_release_publisher_*

# Push the changes to our branch
git config --global user.email "test@example.com"
git config --global user.name "nurupo-test"
git commit -am "Modify upstream repo for building"
git push origin $DIFFERENT_REPO_BRANCH --force > /dev/null 2>&1
