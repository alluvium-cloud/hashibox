storage "raft" {
  path    = "/opt/vault"
  node_id = "home"
}

service_registration "consul" {
  address = "conad-client-3.alluvium.cloud:8500"
}
