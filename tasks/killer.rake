namespace :dynos do
  task :list_over_threshold do
    killer.dynos_over_threshold.each do |dyno|
      if dyno[:memory] == "R14"
        puts "Over threshold (#{ENV["MEMORY_THRESHOLD_IN_MB"]}MB): #{dyno[:name]} with #{dyno[:memory]}"
      else
        difference = dyno[:memory] - ENV["MEMORY_THRESHOLD_IN_MB"].to_f
        puts "Over threshold (#{ENV["MEMORY_THRESHOLD_IN_MB"]}MB): #{dyno[:name]} with #{dyno[:memory]}MB (#{difference.round}MB)"
      end
    end
  end

  task :restart_over_threshold do
    killer.restart.each do |dyno|
      if dyno[:memory] == "R14"
        puts "Restarting (#{ENV["MEMORY_THRESHOLD_IN_MB"]}MB): #{dyno[:name]} with #{dyno[:memory]}MB (#{difference.round}MB)"
      else
        difference = dyno[:memory] - ENV["MEMORY_THRESHOLD_IN_MB"].to_f
        puts "Restarting (#{ENV["MEMORY_THRESHOLD_IN_MB"]}MB): #{dyno[:name]} with #{dyno[:memory]}"
      end
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
