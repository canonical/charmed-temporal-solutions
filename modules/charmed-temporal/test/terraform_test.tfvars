model = "temporal-test"

postgresql = {
  app_name = "postgres"
  channel  = "14/stable"
  units    = 1
}

temporal_server = {
  app_name = "temporal-server"
  channel  = "1.23/edge"
  units    = 1
  config   = {
    num-history-shards = "1"
  }
}

temporal_ui = {
  app_name = "temporal-ui"
  channel  = "1.23/edge"
  units    = 1
  config   = {}
}

temporal_admin = {
  app_name = "temporal-admin"
  channel  = "1.23/edge"
  units    = 1
  config   = {}
}
