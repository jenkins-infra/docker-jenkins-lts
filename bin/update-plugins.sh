#!/usr/bin/env bash

set -ex

list="plugins-*.txt"
if [[ "$#" -eq 1 ]]; then
    list=$1
fi

cd "$(dirname "$0")" || exit 1

echo "Updating plugins"

# Fetches the latest plugin manager version via API, the asset has a version number in it unfortunately
# So we can't just use the API to get the latest version without some parsing
PM_CLI_DOWNLOAD_URL=$(curl -s https://api.github.com/repos/jenkinsci/plugin-installation-manager-tool/releases/latest | jq -r 'first(.assets[] | select(.content_type=="application/x-java-archive" or .content_type=="application/java-archive")).browser_download_url')

TMP_DIR=$(mktemp -d)

wget --no-verbose "${PM_CLI_DOWNLOAD_URL}" -O "${TMP_DIR}/jenkins-plugin-manager.jar"

# Retrieve and check the corresponding sha256 checksum
echo "$(curl --fail --silent --show-error --location "${PM_CLI_DOWNLOAD_URL}.sha256")  ${TMP_DIR}/jenkins-plugin-manager.jar" > /tmp/jenkins_sha
sha256sum --check --strict /tmp/jenkins_sha
rm -f /tmp/jenkins_sha

CURRENT_JENKINS_VERSION=$(head -n 1 ../Dockerfile | cut -d ':' -f 2 | cut -d '-' -f 1)
wget --no-verbose "https://get.jenkins.io/war-stable/${CURRENT_JENKINS_VERSION}/jenkins.war" -O "${TMP_DIR}/jenkins.war"

cd ../ || exit 1

# Iterate through each txt file starting with "plugins-", or the file specified as input
for pluginfile in ${list}; do
    if [ -e "${pluginfile}" ]; then
        echo "Updating plugins file: ${pluginfile}"

        java -jar "${TMP_DIR}/jenkins-plugin-manager.jar" \
            --plugin-file "${pluginfile}" \
            --jenkins-update-center='https://azure.updates.jenkins.io/update-center.json' \
            --jenkins-plugin-info='https://azure.updates.jenkins.io/plugin-versions.json' \
            --available-updates \
            --output txt \
            --war "${TMP_DIR}/jenkins.war" \
        > plugins2.txt

        mv plugins2.txt "${pluginfile}"
    fi
done

rm -rf "${TMP_DIR}"

echo "Updating plugins complete"
