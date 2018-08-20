#!/bin/bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

# export GITHUB_ORGANIZATION="aaron-prindle"
# export GITHUB_REPO="github-releaser"
# export TAG_NAME="vX.Y.Z"
# export TEMPLATE_DIR="templates/github-release-template.txt"
# export GITHUB_TOKEN_BUCKET="gs://project/github-token"

# TODO(aaron-prindle) add validation that all env vars are set
gsutil cp ${GITHUB_TOKEN_BUCKET} .
export GITHUB_TOKEN=$(cat github-token)
export DESCRIPTION=$(exec-template \
                       -json="{\"Version\": \"${TAG_NAME}\"}" \
                       -template=${TEMPLATE_DIR})

# Deleting release from github before creating new one
github-release delete --user ${GITHUB_ORGANIZATION} --repo ${GITHUB_REPO} --tag ${TAG_NAME} || true

# Creating a new release in github
github-release release \
    --user ${GITHUB_ORGANIZATION} \
    --repo ${GITHUB_REPO} \
    --tag ${TAG_NAME} \
    --name "${TAG_NAME}" \
    --description "${DESCRIPTION}"
