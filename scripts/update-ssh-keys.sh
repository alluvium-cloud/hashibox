#!/usr/bin/bash
# ./update_inventory.sh "master-test-1" "worker-test-1 worker-test-2 worker-test-3" "192.168.1.93" "192.168.1.94 192.168.1.95 192.168.1.96"

source ./.env

for HOST in ${HOST_LIST}; do
    echo "--- Update SSH Key: $HOST"
    ssh-keygen -f ~/.ssh/known_hosts -R ${HOST}.${DOMAIN} >/dev/null 2>&1
    ssh -o StrictHostKeyChecking=accept-new -i ~/.ssh/proxmox debian@${HOST} hostname >/dev/null 2>&1
done
