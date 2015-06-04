namespace :dynos do
  task :list_over_threshold do
    puts killer.dynos_over_threshold
  end

  task :restart_over_threshold do
    puts killer.dynos_over_threshold
  end

  def killer
    @_killer ||= HerokuDynoKiller.new(
      {token: ENV["PAPERTRAIL_TOKEN"]},
      {app_name: ENV["APP_NAME"], token: ENV["HEROKU_TOKEN"]},
      ENV["MEMORY_THRESHOLD_IN_MB"].to_f)
  end
end
