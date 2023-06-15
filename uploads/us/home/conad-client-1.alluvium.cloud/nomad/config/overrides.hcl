datacenter = "home"

vault {
  enabled = true
  address = "http://conad-server-1.alluvium.cloud:8200"
}

ui {
  enabled = true

  consul {
    ui_url = "http://conad-server-1.alluvium.cloud:8500/ui"
  }

  vault {
    ui_url = "http://conad-server-1.alluvium.cloud:8200/ui"
  }
}
