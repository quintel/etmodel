module GqlHelper
  # returns a the gquery_id. Fetches and caches the gquery list from the ETE
  # if the id is missing, then return the key passed as parameter.
  # So we can store in the column both ids and gqueries
  def gquery_id(key)
    gquery_map[key] || key
  end
  
  def gquery_map
    Rails.cache.fetch('engine_gqueries_map') do
      Api::Gquery.all.each_with_object({}) do |gquery, hsh|
        hsh[gquery.key] = hsh[gquery.deprecated_key] = gquery.id
      end
    end
  end
  
  # DEBT!
  def block_chart_gqueries_map
    Rails.cache.fetch('block_chart_gqueries_map') do
      gquery_map.select{|k,v| k =~ /in_overview_costs_of_electricity_production/ }
    end
  end
end