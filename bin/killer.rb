require "bundler"
require 'logger'

Bundler.require

# logger = Logger.new(STDOUT)
# logger.level = Logger::INFO

killer = HerokuDynoKiller.new(
  {token: ENV["PAPERTRAIL_TOKEN"]},
  {app_name: ENV["APP_NAME"], token: ENV["HEROKU_TOKEN"]},
  ENV["MEMORY_THRESHOLD_IN_MB"].to_f)

$stdout = STDOUT
$stdout.sync = true

puts "this should go to the logs"
puts killer.dynos_over_threshold

# Restart all dynos that are over threshold. Returns dynos that were restarted.
# killer.restart
