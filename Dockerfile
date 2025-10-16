FROM jenkins/jenkins:2.528.1-jdk21

COPY logos /usr/share/jenkins/ref/userContent/logos
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli \
  --jenkins-update-center='https://azure.updates.jenkins.io/update-center.json' \
  --jenkins-plugin-info='https://azure.updates.jenkins.io/plugin-versions.json' \
  --plugin-file /usr/share/jenkins/ref/plugins.txt \
  --verbose
