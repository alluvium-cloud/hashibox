storage "raft" {
  path    = "/opt/vault"
  node_id = "conad-server-1"
  retry_join {
      leader_api_addr = "http://conad-server-2.alluvium.cloud:8200"
  }
  retry_join {
      leader_api_addr = "http://conad-server-3.alluvium.cloud:8200"
  }
}

service_registration "consul" {
  address = "conad-client-1.alluvium.cloud:8500"
}
