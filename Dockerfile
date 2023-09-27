FROM jenkins/jenkins:2.414.2-jdk17

COPY logos /usr/share/jenkins/ref/userContent/logos
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt --verbose
