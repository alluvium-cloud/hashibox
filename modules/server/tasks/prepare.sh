#!/bin/bash
COREDNS_VERSION='1.10.1'
# Install required and useful packages.
sudo apt-get install -y \
  curl \
  unzip \
  vim \
  apt-transport-https \
  ca-certificates \
  gnupg-agent \
  software-properties-common

# Create the HashiBox environment file.
touch /hashibox/.env

# Add Tailscale
curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get -y install tailscale

# Add CoreDNS
sudo wget -nv https://github.com/coredns/coredns/releases/download/v${COREDNS_VERSION}/coredns_${COREDNS_VERSION}_linux_amd64.tgz -O /tmp/coredns.tgz 2>&1
sudo tar -xvvf /tmp/coredns.tgz --directory /tmp
sudo chmod +x /tmp/coredns
sudo mv /tmp/coredns /usr/local/bin
sudo mkdir -p /opt/coredns /etc/coredns
sudo useradd -d /var/lib/coredns -m coredns
sudo chown coredns:coredns /opt/coredns

# Add the appropriate CoreDNS systemd service.
sudo cp /hashibox/defaults/coredns/coredns.service /etc/systemd/system/coredns.service

# Restart CoreDNS
sudo systemctl daemon-reload
sudo systemctl restart coredns

# Forward default DNS port 53 to CoreDNS port 5353 (done so we can run CoreDNS as a non-root user)
iptables -t nat -F
iptables -t nat -A PREROUTING -p udp -m udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A OUTPUT -d localhost -p udp -m udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A OUTPUT -d localhost -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 5353

# Flip Host DNS to CoreDNS
sudo rm /etc/resolv.conf
echo 'nameserver 127.0.0.1' | sudo tee /etc/resolv.conf > /dev/null