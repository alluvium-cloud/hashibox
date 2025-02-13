
.PHONY: init up halt restart destroy sync update ssh wipe nl cl vl
-include .env

nl:
	pdsh -g all sudo tail -f /var/log/syslog  | grep nomad | grep -v coredns

cl:
	pdsh -g all sudo tail -f /var/log/syslog  | grep consul | grep -v coredns

vl:
	pdsh -g all sudo tail -f /var/log/syslog  | grep vault | grep -v coredns

wipe:
	./scripts/init/wipe.sh
	./scripts/init/reset-env.sh
#
# init is a shortcut to initialize the HashiBox environment for the first time.
# Apply the environment variables before installing so we know if we need OSS
# or Enterprise version for Consul, Nomad, and Vault. We need to apply them after
# installation as well since `.env` is now populated with Vault unseal key and
# root token. We then can unseal Vault, bootstrap ACLs on Consul and Nomad,
# initialize Vault as CA provider for Consul Connect, and finally sync files with
# the result of the bootstrap process. Last step is to create the Consul and Nomad
# secret engines on Vault. We wait 45 seconds before doing this step to ensure a
# Vault node is "active".
#
init:
	./scripts/upload.sh
	./scripts/dotenv.sh
	./scripts/init/install.sh
	sleep 5
	./scripts/init/vault-init.sh
	sleep 5
	./scripts/dotenv.sh
	./scripts/restart.sh
	sleep 10
	./scripts/unseal.sh
	sleep 3
	./scripts/init/consul-bootstrap.sh
	sleep 10
	./scripts/init/nomad-bootstrap.sh
	sleep 10
	make sync
	sleep 60
	./scripts/init/consul-ca.sh
	./scripts/init/vault-engines.sh

#
# up is a shortcut to start the Vagrant environment. If you made some changes in
# `.env` or configuration files, you'll need to execute `make sync` after.
#
up:
	vagrant up --provider=${VAGRANT_PROVIDER} --parallel
	./scripts/restart.sh
	sleep 5
	./scripts/unseal.sh

#
# halt is a shortcut to stop the Vagrant environment.
#
halt:
	vagrant halt

#
# restart is a shortcut to properly stop and restart the Vagrant environment.
#
restart: halt up

#
# destroy is a shortcut to stop and force destroy the Vagrant environment.
#
destroy: halt
	vagrant destroy -f --parallel

#
# sync is a shortcut to synchronize the local `uploads` directory with the
# appropriate targeted nodes. It also applies some environment variables, then
# restarts the Consul, Nomad, and Vault services and finally unseal Vault on
# every server nodes.
#
sync:
	./scripts/upload.sh
	./scripts/dotenv.sh
	./scripts/restart.sh
	sleep 5
	./scripts/unseal.sh

#
# update is a shortcut to update Consul, Nomad, Vault, and Docker on every nodes.
# It also unseal Vault on every server nodes.
#
update:
	./scripts/update.sh
	sleep 5
	./scripts/unseal.sh

#
# ssh is a shortcut to ensure that the Nomad user's known hosts file is
# populated with GitHub and Bitbucket hosts, as described here:
# https://www.nomadproject.io/docs/job-specification/artifact#download-using-git
#
ssh:
	bolt command run "sudo mkdir -p /root/.ssh" --targets=us --run-as root
	bolt command run "ssh-keyscan github.com | sudo tee -a /root/.ssh/known_hosts" --targets=us --run-as root
	bolt command run "ssh-keyscan bitbucket.org | sudo tee -a /root/.ssh/known_hosts" --targets=us --run-as root
