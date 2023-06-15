#!/bin/bash

# Run the "install" plan on server and client nodes.
bolt plan run server::wipe --targets=servers --run-as root &
  bolt plan run client::wipe --targets=clients --run-as root &
  wait
