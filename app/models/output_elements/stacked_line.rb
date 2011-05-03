class OutputElement < ActiveRecord::Base


  def series_bezier
    series = []
    
    allowed_output_element_series.each do |serie|
      result = Current.gql.query(serie.key)
      series << result.map{|year,value| [year,value]}
    end

    
    smallest_scale = Metric.scaled_value([series.map{|present,future|[ present.last.abs]}.flatten.sum,series.map{|present,future|[ future.last.abs]}.flatten.sum].min,:start_scale => 3).first

    
    series = series.map{|x| x.map{|year,value| [year,Metric.scaled_value(value,:start_scale => 3,:target_scale =>smallest_scale).last]}}


    unit = parsed_unit(smallest_scale)
    [series,growth_chart,unit]
  end

end
