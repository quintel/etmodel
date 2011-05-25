# TODO: add caching, multiple queries, etc
class Api::Query
  include HTTParty
  base_uri APP_CONFIG[:api_url]
  
  attr_accessor :query, :api_session_id
  
  def execute
    return false unless query
    url = "/api_scenarios/#{api_session_id}.json"
    request_params = { result: [query]}
    response = self.class.get(url, :query => request_params)
    @result = response["result"]
  end
  
  # To be used on queries that return a single value
  # (query => result)
  def fetch_single_value
    execute
    @result.values.first
  end
  
  # useful for debugging
  def fresh_session_id
    response = self.class.get("/api_scenarios/new.json")
    self.api_session_id = response["api_scenario"]["api_session_key"]
  end
end