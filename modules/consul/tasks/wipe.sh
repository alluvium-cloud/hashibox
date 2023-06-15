#!/bin/bash

# Stop the current Consul agent.
sudo systemctl stop consul

# Reset Consul Config
sudo rm -rfv /etc/consul/*

# Reset Consul Data
sudo rm -rfv /var/consul/*
