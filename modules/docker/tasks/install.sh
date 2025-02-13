#!/bin/bash

# Set Docker version.
DOCKER_VERSION="stable"

# Set OS details.
OS_KIND="linux"
OS_DISTRO="debian"
OS_ARCH="amd64"
case $(uname -m) in
  aarch64) OS_ARCH="arm64" ;;
esac

# Remove previous Docker-related packages.
sudo apt-get remove \
  docker \
  docker-engine \
  docker.io \
  containerd \
  runc

# Add Docker’s official GPG key.
curl -fsSL https://download.docker.com/${OS_KIND}/${OS_DISTRO}/gpg | sudo apt-key add -

# Verify that the key with the fingerprint.
sudo apt-key fingerprint 0EBFCD88

# Setup the appropriate Docker repository.
sudo add-apt-repository \
  "deb [arch=${OS_ARCH}] https://download.docker.com/${OS_KIND}/${OS_DISTRO} \
  $(lsb_release -cs) \
  ${DOCKER_VERSION}"

# Update
sudo apt update

# Install the latest version of Docker Engine - Community and containerd.
sudo apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io

# Restart Docker to make sure we get the latest version of the daemon if there
# is an upgrade
sudo service docker stop

# Make sure we can actually use Docker as the current user.
sudo usermod -aG docker $USER
