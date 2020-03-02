class PapertrailClient
  def initialize config
    @token = config[:token]
  end

  # Read all logs that that output memory
  def events
    response = RestClient.get 'https://papertrailapp.com/api/v1/events/search.json?q=heroku%2Fweb+sample%23memory_total%3D+OR+"error+r14"',
      {"X-Papertrail-Token" => @token}
    data = JSON.parse(response.to_str)
    data["events"]
  end
end
