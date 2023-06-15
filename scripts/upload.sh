#!/bin/bash

# Make sure a `hashibox` directory exists. It's not the case when initializing
# the Vagrant environment for the first time. If this directory doesn't exist
# then all uploads and services will fail since it relies on it.
bolt command run "mkdir -p /hashibox" --targets=us --run-as root

# Make sure to start with empty `defaults` and `overrides` directories so there
# is no conflict when uploading files. We don't simply remove the `hashibox`
# directory since it contains the `.env` file containing environment variables
# written when starting the Vagrant box.
bolt command run "rm -rf /hashibox/defaults /hashibox/overrides" --targets=us --run-as root

# Upload default configuration files for agents acting as servers. Also, upload
# specific configuration file per node to override default behavior.
bolt file upload ./uploads/us/_defaults/server /hashibox/defaults --targets=servers --run-as root &
  bolt file upload ./uploads/us/home/conad-server-1.alluvium.cloud /hashibox/overrides --targets=conad-server-1.alluvium.cloud --run-as root &
  bolt file upload ./uploads/us/home/conad-server-2.alluvium.cloud /hashibox/overrides --targets=conad-server-2.alluvium.cloud --run-as root &
  bolt file upload ./uploads/us/home/conad-server-3.alluvium.cloud /hashibox/overrides --targets=conad-server-3.alluvium.cloud --run-as root &
  wait

# Upload default configuration files for agents acting as clients. Also, upload
# specific configuration file per node to override default behavior.
bolt file upload ./uploads/us/_defaults/client /hashibox/defaults --targets=clients --run-as root &
  bolt file upload ./uploads/us/home/conad-client-1.alluvium.cloud /hashibox/overrides --targets=conad-client-1.alluvium.cloud --run-as root &
  bolt file upload ./uploads/us/home/conad-client-2.alluvium.cloud /hashibox/overrides --targets=conad-client-2.alluvium.cloud --run-as root &
  bolt file upload ./uploads/us/home/conad-client-3.alluvium.cloud /hashibox/overrides --targets=conad-client-3.alluvium.cloud --run-as root &
  wait
