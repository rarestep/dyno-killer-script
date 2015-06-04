require "heroku_dyno_killer"

killer = HerokuDynoKiller.new(
  {token: ENV["PAPERTRAIL_TOKEN"]},
  {app_name: ENV["APP_NAME"], token: ENV["HEROKU_TOKEN"]},
  ENV["MEMORY_THRESHOLD_IN_MB"])

# Restart all dynos that are over threshold. Returns dynos that were restarted.
killer.restart
