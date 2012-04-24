class AdaptCostChartSeries < ActiveRecord::Migration
  def self.up
    OutputElementSerie.find_all_by_output_element_id(32).each do |os|
      base_key = "cost_chart_#{os.short_label.downcase.underscore.gsub(/\s+/, '_')}"
      os.update_attributes :gquery => base_key, :key => ''
    end; nil
  end

  def self.down
  end
end
