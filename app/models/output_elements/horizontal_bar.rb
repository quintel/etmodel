class OutputElement < ActiveRecord::Base

  def series_horizontal_bar
    series = []
    allowed_output_element_series.reject{|s|s.is_target}.each_with_index do |serie,i|
      series << [Current.gql.query(serie.key).round(3),i+1]
    end
    [series,show_point_label,unit]
  end

# dry up with vertical bar
  def axis_values_horizontal_bar
    [0,axis_scale(@options.first.map{|x| x.first}.flatten.max)]
  end
end
