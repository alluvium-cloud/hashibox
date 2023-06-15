#!/bin/bash

# Make sure to include required environment variables.
source .env

# Bootstrap Nomad ACLs, and save the bootstrap token in environment variables.
bootstrap=$(NOMAD_ADDR=http://conad-server-1.alluvium.cloud:4646 nomad acl bootstrap -json)
token=$(jq -r .SecretID <<< "${bootstrap}")
echo "export NOMAD_TOKEN=${token}" | tee -a ./.env &> /dev/null

echo "${bootstrap}" | tee -a bootstrap.log &> >/dev/null