#!/bin/bash

# Stop the current Vault agent.
sudo systemctl stop vault
sudo systemctl stop vault-agent

# Reset Vault Config
sudo rm -rfv /etc/vault/*

# Reset Vault Data
sudo rm -rfv /opt/vault

# Reset Vault Agent Config
sudo rm -rfv /etc/vault-agent/*

sudo rm -rfv /hashibox