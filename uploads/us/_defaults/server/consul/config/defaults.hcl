data_dir = "/opt/consul"

datacenter = "us"

ui_config {
  enabled = true
}

bootstrap_expect           = 3
enable_local_script_checks = true

server = true

client_addr        = "{{ GetInterfaceIP \"eth0\" }}"
advertise_addr     = "{{ GetInterfaceIP \"eth0\" }}"
advertise_addr_wan = "{{ GetInterfaceIP \"eth0\" }}"

ports {
  http = 8500
  grpc = 8502
  dns  = 8600
}

retry_join = [
  "conad-server-1.alluvium.cloud",
  "conad-server-2.alluvium.cloud",
  "conad-server-3.alluvium.cloud"
]

acl {
  enabled        = true
  default_policy = "deny"
  down_policy    = "deny"

  enable_token_persistence = true

  tokens {
    default = "<CONSUL_HTTP_TOKEN_TO_OVERRIDE>"
  }
}

connect {
  enabled = true
}
