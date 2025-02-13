api_addr     = "http://{{ GetInterfaceIP \"eth0\" }}:8200"
cluster_addr = "http://{{ GetInterfaceIP \"eth0\" }}:8201"

ui = true

disable_mlock = true

listener "tcp" {
  tls_disable     = true
  address         = "{{ GetInterfaceIP \"eth0\" }}:8200"
  cluster_address = "{{ GetInterfaceIP \"eth0\" }}:8201"

  telemetry {
    unauthenticated_metrics_access = true
  }
}

telemetry {
  prometheus_retention_time = "24h"
  disable_hostname          = true
}
