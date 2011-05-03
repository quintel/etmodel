class MigrateGraphQueriesToGql < ActiveRecord::Migration
  def self.up
    OutputElementSerie.all.each do |serie|
      q = serie.key
      if graph_query_key = q[/sum\.graph\.(.*)/,1]
        graph_query_key = "co2_emission_total" if graph_query_key == "total_co2_emission"
        serie.update_attribute :key, "Q(#{graph_query_key})"
      end
    end
  end

  def self.down
  end
end
