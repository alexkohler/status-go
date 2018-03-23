#!/usr/bin/env bash

# This script ensures the current branch has the most up to date autogenerated files.

# Exit early if errors are encountered
set -e

currentBranch=$(git rev-parse --abbrev-ref HEAD)

function finish {
   git checkout --quiet $currentBranch
   git branch --quiet -D autogen-test-branch || true
}
trap finish EXIT

go get -u github.com/jteeuwen/go-bindata/...
git branch -D --quiet autogen-test-branch || true
git checkout -b autogen-test-branch
make -s generate

if $(git diff --cached --quiet); then
    echo "Branch assets not up to date. Please rerun make generate."
    exit 1
fi