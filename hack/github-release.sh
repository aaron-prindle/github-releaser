export GITHUB_ORGANIZATION="aaron-prindle"
export GITHUB_REPO="github-releaser"
export PROJECT_NAME="github-releaser"
export TAG_NAME="vX.Y.Z"

export GITHUB_TOKEN=$(gsutil cp gs://aprindle-stuff/github-token)
export DESCRIPTION=$(exec-template \
                       -json='{"Version": "${TAG_NAME}"' \
                       -template='templates/github-release-template.txt')

# Deleting release from github before creating new one
github-release delete --user ${GITHUB_ORGANIZATION} --repo ${GITHUB_REPO} --tag ${TAG_NAME} || true

# Creating a new release in github
github-release release \
    --user ${GITHUB_ORGANIZATION} \
    --repo ${GITHUB_REPO} \
    --tag ${TAG_NAME} \
    --name "${TAG_NAME}" \
    --description "${DESCRIPTION}"
