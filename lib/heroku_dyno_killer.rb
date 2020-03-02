require_relative "papertrail/client.rb"
require_relative "heroku/client.rb"
require 'platform-api'
require "rest-client"

class HerokuDynoKiller
  def initialize papertrail_config, heroku_config, threshold
    @papertrail = PapertrailClient.new(papertrail_config)
    @heroku = HerokuClient.new(heroku_config)

    @threshold = threshold
  end

  # Restart all dynos that are over the threshold. Returns dynos that were
  # restarted.
  def restart
    restarts = []

    dynos_over_threshold.each do |dyno|
      @heroku.restart(dyno[:name])
      restarts.push dyno
    end

    restarts
  end

  # Returns all dynos over threshold.
  def dynos_over_threshold
    dynos.select do |dyno|
      (dyno[:memory] == "R14" || dyno[:memory] >= @threshold) && ((DateTime.now - DateTime.parse(dyno[:timestamp])).to_f * 24 * 60).to_i <= 6
    end
  end

  private

  # Get all dynos and their memory usage from papertrail logs.
  def dynos
    data = {}
    @papertrail.events.each do |event|
      data[dyno_name_from_event(event)] = [memory_from_event(event), event["received_at"]]
    end

    data.map do |k, v|
      {name: k, memory: v[0], timestamp: v[1]}
    end
  end

  # Extract dyno name from log
  def dyno_name_from_event(event)
    event["program"].gsub("heroku/", "")
  end

  # Extract dyno memory from log
  def memory_from_event(event)
    if event["message"].scan(/Error R14/).length > 0
      "R14"
    else
      event["message"].scan(/sample#memory_total=(\d+\.\d*)/).last.first.to_f
    end
  end
end
