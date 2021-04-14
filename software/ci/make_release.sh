#!/bin/bash

set -x
set -e

# adapted from https://medium.com/@systemglitch/continuous-integration-with-jenkins-and-github-release-814904e20776


# Publish on github
echo "Publishing on Github..."
token=${GITHUB_ACCESS_TOKEN}

git fetch --tags

# Get the last tag name
tag=$(git describe --tags)

if [ X$tag == X ]; then
    echo "no tags found"
    exit
fi

# Get the full message associated with this tag
message="$(git for-each-ref refs/tags/$tag --format='%(contents)')"

# Get the title and the description as separated variables
name=$(echo "$message" | head -n1)
description=$(echo "$message" | tail -n +3)
description=$(echo "$description" | sed -z 's/\n/\\n/g') # Escape line breaks to prevent json parsing problems

# Create a release
release=$(curl -XPOST -H "Authorization:token $token" \
	       --data "{\"tag_name\": \"$tag\", \"target_commitish\": \"master\", \"name\": \"$name\", \"body\": \"$description\", \"draft\": false, \"prerelease\": true}" \
	       https://api.github.com/repos/AliceO2Group/alice-fit-fpga/releases)

# Extract the id of the release from the creation response
id=$(echo "$release" | sed -n -e 's/"id":\ \([0-9]\+\),/\1/p' | head -n 1 | sed 's/[[:blank:]]//g')

echo ${tag},${name},${message},${description},${release},${id}

# create the build artifact to be uploaded to GitHub
cd ${BITSTREAMS_DIR}
ARTIFACT=${BUILD_DIR}.zip
rm -f ${ARTIFACT} && zip -r ${ARTIFACT} ${BUILD_DIR}/

# Upload the artifact
curl -XPOST -H "Authorization:token $token" \
     -H "Content-Type:application/octet-stream" \
     --data-binary @${ARTIFACT} https://uploads.github.com/repos/AliceO2Group/alice-fit-fpga/releases/$id/assets?name=${ARTIFACT}
