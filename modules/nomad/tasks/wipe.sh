#!/bin/bash

# Stop the current Nomad agent.
sudo systemctl stop nomad

# Reset Nomad Config
sudo rm -rfv /etc/nomad/*

# Reset Nomad Data
sudo rm -rfv /var/nomad
sudo rm -rfv /opt/nomad
