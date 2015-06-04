require "bundler"
Bundler.require

killer = HerokuDynoKiller.new(
  {token: ENV["PAPERTRAIL_TOKEN"]},
  {app_name: ENV["APP_NAME"], token: ENV["HEROKU_TOKEN"]},
  ENV["MEMORY_THRESHOLD_IN_MB"].to_f)

$stdout.print killer.dynos_over_threshold
$stdout.flush

# Restart all dynos that are over threshold. Returns dynos that were restarted.
# killer.restart
