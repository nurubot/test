#!/usr/bin/env bash

set -exuo pipefail

cd .travis/tools/continuous_release
pip install -r requirements.txt
python ./continuous_release.py store /tmp/deploy
