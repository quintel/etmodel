module GqlHelper
  # returns a the gquery_id. Fetches and caches the gquery list from the ETE
  # if the id is missing, then return the key passed as parameter.
  # So we can store in the column both ids and gqueries
  def gquery_id(key)
    gqueries = Rails.cache.fetch('engine_gqueries') do
      h = {}
      Api::Gquery.all.map do |g|
        h[g.key] = g.id
        h[g.deprecated_key] = g.id if g.deprecated_key 
      end
      h
    end
    id = gqueries[key] || key
  end
end