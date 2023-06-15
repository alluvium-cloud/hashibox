datacenter = "home"

vault {
  enabled = true
  address = "http://conad-server-3.alluvium.cloud:8200"
}

ui {
  enabled = true

  consul {
    ui_url = "http://conad-server-3.alluvium.cloud:8500/ui"
  }

  vault {
    ui_url = "http://conad-server-3.alluvium.cloud:8200/ui"
  }
}
