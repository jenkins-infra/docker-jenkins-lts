#!/bin/bash

set -eux -o pipefail

new_plugins_file="${1}"
orig_plugins_file="${2}"
diff_file="$(mktemp)"

# Store comparison between original and updated
diff --unified=0 "${orig_plugins_file}" "${new_plugins_file}" > "${diff_file}" || true
if [ -s "${diff_file}" ]
then
  pluginsdiff="$(tail --lines +3 "${diff_file}" | grep -v '@')"
  newlines=$(echo "${pluginsdiff}" | grep '+')
  links='<ul>'
  while read -r line
  do
    pluginName=${line%:*}
    pluginVersion=${line#*:}
    links+="<li><a href=\"https://plugins.jenkins.io/${pluginName//+}/releases/#version_${pluginVersion}\" rel=\"noreferrer\" target=\"_blank\">${pluginName//+}:${pluginVersion}</a></li>"
  done <<< "$newlines"
  links+='</ul>'

  echo "${links}"
fi
