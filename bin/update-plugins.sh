#!/usr/bin/env bash

set -ex

cd "$(dirname "$0")" || exit 1

echo "Updating plugins"

# Fetches the latest plugin manager version via API, the asset has a version number in it unfortunately
# So we can't just use the API to get the latest version without some parsing
PM_CLI_DOWNLOAD_URL=$(curl -s 'https://api.github.com/repos/jenkinsci/plugin-installation-manager-tool/releases/latest' | jq -r '.assets[] | select(.content_type=="application/x-java-archive").browser_download_url')

TMP_DIR=$(mktemp -d)

wget --no-verbose "${PM_CLI_DOWNLOAD_URL}" -O "${TMP_DIR}/jenkins-plugin-manager.jar"

CURRENT_JENKINS_VERSION=$(head -n 1 ../Dockerfile | cut -d ':' -f 2 | cut -d '-' -f 1)
wget --no-verbose "https://get.jenkins.io/war-stable/${CURRENT_JENKINS_VERSION}/jenkins.war" -O "${TMP_DIR}/jenkins.war"

cd ../ || exit 1

java -jar "${TMP_DIR}/jenkins-plugin-manager.jar" -f plugins.txt --available-updates --output txt --war "${TMP_DIR}/jenkins.war"  > plugins2.txt

mv plugins2.txt plugins.txt

git diff plugins.txt

echo "Updating plugins complete"

rm -rf "${TMP_DIR}"
