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

class Api::Client
  include HTTParty
  base_uri APP_CONFIG[:api_url]

  attr_accessor :queries, :api_session_id

  def initialize
    self.queries = []
  end

  def simple_query(q)
    unless got_result?(q)
      self.queries << q
      execute!
    end
    parse_result(q)
  end

  # ignore cached results
  def simple_query!(q)
    @results = nil
    simple_query(q)
  end

  # useful for debugging, whenever possible you'd rather recycle
  # an existing session
  def fetch_session_id
    settings = { :settings => Current.setting.new_settings_hash } rescue nil
    if settings
      response = self.class.get("/api_scenarios/new.json", :query => settings)
    else
      response = self.class.get("/api_scenarios/new.json")
    end
    
    result = response["api_scenario"]["api_session_key"] rescue nil
    
    if result
      self.api_session_id = result
      Rails.logger.debug("Got api_session_id: #{result}")
    else
      Rails.logger.debug("Error fetching api_session_id")
    end
    result
  end

  private

    # no caching, always fresh data
    def results!
      @results = execute!
    end

    # caching results
    def results
      @results ||= execute!
    end

    # DEBT: deal with falsy values
    def got_result?(q)
      @results && @results[q]
    end

    # Data is returned in different ways. Sometimes it is enclosed
    # in an array:
    # ruby-1.9.2-p180 :011 > Current.gql.query "present:V(1.0)"
    # => [1.0]
    #
    # Sometimes not:
    # Current.gql.query "present:NIL()"
    # => nil
    def parse_single_value(data)
      if data.is_a?(Array)
        data[0].to_f
      else
        data.to_f
      end
    end

    # returns data in this format: {2010 => 1.0, 2040 => 1.0}
    #
    # ruby-1.9.2-p180 :006 > Current.gql.query "V(1.0)"
    # => [[2010, [1.0]], [2040, [1.0]]]  # enclosed in an array
    #
    # ruby-1.9.2-p180 :004 > Current.gql.query "Q(policy_not_shown)"
    # => [[2010, 0.6045053247669468], [2040, 0.6045053247669468]] # not!
    #
    # DEBT: deal with queries that return arrays or strings!
    def parse_pair(data)
      {
        data[0][0] => data[0][1].kind_of?(Array) ? data[0][1][0].to_f : data[0][1].to_f,
        data[1][0] => data[1][1].kind_of?(Array) ? data[1][1][0].to_f : data[1][1].to_f,
      }
    rescue
      false
    end

    def parse_result(key)
      data = results[key]
      return nil unless data
      if data.kind_of?(Array) && data.size == 2
        return parse_pair(data)
      else
        return parse_single_value(data)
      end
    rescue
      nil
    end

    def execute!
      q = queries.uniq.flatten
      return [] if q.nil? || q.empty?
      session_id = api_session_id || fetch_session_id
      url = "/api_scenarios/#{session_id}.json"
      request_params = { result: q }
      response = self.class.get(url, :query => request_params)
      @results = response["result"]
    end
end