# docker-jenkins-lts


a docker image containing the latest jenkins lts release and plugins, published here: https://hub.docker.com/r/jenkinsciinfra/jenkins-lts

## Updating Plugins

```
uc update --determine-version-from-dockerfile --display-updates -w
```

## Update Jenkins Version

```
VERSION=$(jv get --version-identifier lts)
SUFFIX=lts-jdk11
FULL_VERSION=jenkins/jenkins:${VERSION}-${SUFFIX}
sed -i 's|FROM .*|FROM '"${FULL_VERSION}"'|' Dockerfile
```
