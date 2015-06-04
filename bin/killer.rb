require "bundler"
require 'logger'

Bundler.require

$stdout.sync = true
logger = Logger.new(STDOUT)
logger.level = Logger::INFO

killer = HerokuDynoKiller.new(
  {token: ENV["PAPERTRAIL_TOKEN"]},
  {app_name: ENV["APP_NAME"], token: ENV["HEROKU_TOKEN"]},
  ENV["MEMORY_THRESHOLD_IN_MB"].to_f)

logger.error killer.dynos_over_threshold

# Restart all dynos that are over threshold. Returns dynos that were restarted.
# killer.restart
