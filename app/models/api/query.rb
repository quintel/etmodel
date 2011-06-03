# This is how we receive the data (array):
#
# {
#  "AREA(number_of_existing_households)" => [[2010, 6228292.0], [2040, 6228292.0]],
#  "AREA(number_households)"=>[[2010, 7242200.0], [2040, 7242200.0]]
# }
#
# or scalar:
#
# {
#   "present:DIVIDE(blah blah blah)" => 0.002075001971257579
# }
#

class Api::Query
  include HTTParty
  base_uri APP_CONFIG[:api_url]
  
  attr_accessor :queries, :api_session_id

  def initialize
    self.queries = []
  end

  # returns data as scalar value
  def fetch_single_value(q)
    res = execute[q]
    if res.is_a?(Array)
      res[0][1].to_f
    else
      res.to_f
    end
  rescue
    nil
  end

  # returns data in this format: {2010 => 1.0, 2040 => 1.0}
  # DEBT: some commands return a value not enclosed in a hash!
  # 
  # ruby-1.9.2-p180 :006 > Current.gql.query "V(1.0)"
  # => [[2010, [1.0]], [2040, [1.0]]]  # enclosed in an array
  # 
  # ruby-1.9.2-p180 :004 > Current.gql.query "Q(policy_not_shown)"
  # => [[2010, 0.6045053247669468], [2040, 0.6045053247669468]] # not!
  #
  def fetch_pair(q)
    res = execute[q]
    {
      res[0][0] => res[0][1].kind_of?(Array) ? res[0][1][0].to_f : res[0][1].to_f,
      res[1][0] => res[1][1].kind_of?(Array) ? res[1][1][0].to_f : res[1][1].to_f,
    }
  # rescue
  #   nil
  end
  
  # Fast statement execution
  # DEBT: this class interface sucks
  def fast_pair(q)
    self.queries = [q]
    Rails.logger.debug "*** GQL: #{q}"
    execute!
    fetch_pair(q)
  end
  
  def execute
    @result ||= execute!
  end

  def execute!
    return false unless queries.any? and api_session_id
    url = "/api_scenarios/#{api_session_id}.json"
    request_params = { result: queries }
    response = self.class.get(url, :query => request_params)
    @result = response["result"]
  end
  
  # useful for debugging
  def fresh_session_id
    response = self.class.get("/api_scenarios/new.json")
    self.api_session_id = response["api_scenario"]["api_session_key"]
  end
end