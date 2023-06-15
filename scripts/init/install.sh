#!/bin/bash

# Run the "install" plan on server and client nodes.
bolt plan run server::install --verbose --targets=servers --run-as root &
  bolt plan run client::install --verbose --targets=clients --run-as root &
  wait
