module GqlHelper
  # returns a the gquery_id. Fetches and caches the gquery list from the ETE
  # if the id is missing, then return the key passed as parameter.
  # So we can store in the column both ids and gqueries
  def gquery_id(key)
    gqueries = Rails.cache.fetch('engine_gqueries') do
      h = {}; Api::Gquery.all.map{|g| h[g.key] = g.id }; h
    end
    id = gqueries[key] || key
  end
end