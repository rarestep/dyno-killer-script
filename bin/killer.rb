require "bundler"
Bundler.require

$stdout.sync = true

killer = HerokuDynoKiller.new(
  {token: ENV["PAPERTRAIL_TOKEN"]},
  {app_name: ENV["APP_NAME"], token: ENV["HEROKU_TOKEN"]},
  ENV["MEMORY_THRESHOLD_IN_MB"].to_f)

puts killer.dynos_over_threshold

# Restart all dynos that are over threshold. Returns dynos that were restarted.
# killer.restart
