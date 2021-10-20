class Api::Scenario < ActiveResource::Base
  self.site = "#{Settings.api_url}/api/v3"

  def self.url_to(path)
    "#{ Settings.api_url }/api/v3/scenarios/#{ path }"
  end

  def self.batch_load(ids, options = {})
    return [] if ids.empty?

    url = url_to("#{ids.uniq.join(',')}/batch")
    res = HTTParty.get(url, options)

    if res.code == 200
      res.map { |scn| new(scn) }
    else
      Raven.capture_message('Scenario batch load failed', level: :error, extra: { url: url })
      []
    end
  end

  def self.find_with_queries(id, queries)
    HTTParty.put(
      "#{ Settings.api_url }/api/v3/scenarios/#{ id }",
      body: { gqueries: Array(queries) }
    )
  end

  # Public: Determines if this scenario can be loaded.
  def loadable?
    Api::Area.code_exists?(area_code)
  end

  # The JSON request returns a string. Let's make it a DateTime object
  def created_at
    Time.parse(attributes[:created_at]).utc if attributes[:created_at]
  end

  def updated_at
    Time.parse(attributes[:updated_at]).utc
  end

  def days_old
    (Time.now.utc - updated_at) / 60 / 60 / 24
  end

  # Returns an HTTParty::Reponse object with a hash of the scenario user_values
  def all_inputs
    HTTParty.get(self.class.url_to("#{ id }/inputs"))
  end

  # The value which is used for sorting. Used on the preset scenario list
  def sorting_value
    respond_to?(:ordering) ? ordering : 0
  end
end
