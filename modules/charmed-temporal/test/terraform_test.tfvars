model = "temporal-test"

postgresql = {
  app_name = "postgres"
  channel  = "14/stable"
  revision = 495
  units    = 1
  config   = {}
}

temporal_server = {
  app_name = "temporal-server"
  channel  = "1.23/edge"
  revision = 58
  units    = 1
  config   = {
    num-history-shards = "4"
  }
}

temporal_ui = {
  app_name = "temporal-ui"
  channel  = "1.23/edge"
  revision = 24
  units    = 1
  config   = {}
}

temporal_admin = {
  app_name = "temporal-admin"
  channel  = "1.23/edge"
  revision = 22
  units    = 1
  config   = {}
}
