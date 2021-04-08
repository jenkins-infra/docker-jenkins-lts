# docker-jenkins-lts


a docker image containing the latest jenkins lts release and plugins

## Updating Plugins

```
uc update --determine-version-from-docker-file --display-updates -w
```

## Update Jenkins Version

```
VERSION=$(jv get --version-identifier lts)
SUFFIX=lts-jdk11
FULL_VERSION=jenkins/jenkins:${VERSION}-${SUFFIX}
sed -i 's|FROM .*|FROM '"${FULL_VERSION}"'|' Dockerfile
```
