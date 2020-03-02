class HerokuClient
  def initialize(config)
    @app_name = config[:app_name]

    @client = PlatformAPI.connect_oauth(config[:token])
  end

  def restart(process_name)
    @client.dyno.restart(@app_name, process_name)
  end
end
