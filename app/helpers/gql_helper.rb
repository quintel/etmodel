module GqlHelper
  # returns a the gquery_id. Fetches and caches the gquery list from the ETE
  def gquery_id(key)
    gqueries = Rails.cache.fetch('engine_gqueries') do
      h = {}; Api::Gquery.all.map{|g| h[g.key] = g.id }; h
    end
    gqueries[key] rescue nil
  end
end