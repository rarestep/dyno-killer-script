namespace :dynos do
  task :list_over_threshold do
    killer.dynos_over_threshold.each do |dyno|
      difference = dyno[:memory] - ENV["MEMORY_THRESHOLD_IN_MB"].to_f
      puts "Over threshold (#{ENV["MEMORY_THRESHOLD_IN_MB"]}MB): #{dyno[:name]} with #{dyno[:memory]}MB (#{difference.round}MB)"
    end
  end

  task :restart_over_threshold do
    killer.restart.each do |dyno|
      difference = dyno[:memory] - ENV["MEMORY_THRESHOLD_IN_MB"].to_f
      puts "Restarting (#{ENV["MEMORY_THRESHOLD_IN_MB"]}MB): #{dyno[:name]} with #{dyno[:memory]}MB (#{difference.round}MB)"
    end
  end

  private

  def killer
    @_killer ||= HerokuDynoKiller.new(
      {token: ENV["PAPERTRAIL_TOKEN"]},
      {app_name: ENV["APP_NAME"], token: ENV["HEROKU_TOKEN"]},
      ENV["MEMORY_THRESHOLD_IN_MB"].to_f)
  end
end
