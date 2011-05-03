class OutputElement < ActiveRecord::Base

  def series_vertical_stacked_bar
    series = {}
    targets = []
    ticks = []
    filler = []

    allowed_output_element_series.reject{|s|s.is_target}.each_with_index do |serie,i|
      series[i] = [] unless series[i]
      series[i] << Current.gql.query_future(serie.key)
      filler << {}
    end
    all_series = series.each.collect{|x| x.last } unless all_series
    unless percentage
      smallest_scale = Metric.scaled_value([all_series.map{|x|[ x.first]}.flatten.sum,all_series.map{|x|[x.last]}.flatten.sum].min,:start_scale => 3).first
      all_series = all_series.map{|x| x.map{|value| Metric.scaled_value(value,:start_scale => 3,:target_scale =>smallest_scale).last}}
      @all_series_without_targets = all_series
    end
    allowed_output_element_series.select{|s|s.is_target}.each do |serie|
      result = Current.gql.query(serie.key)
      result = Metric.scaled_value(result,:start_scale => 3,:target_scale =>smallest_scale).last unless percentage
      x = serie.position.to_f
      all_series << [[x - 0.4, result], [x + 0.4, result]]
    end
    ticks << Current.scenario.start_year
    ticks << Current.scenario.end_year
    [all_series,ticks,filler,show_point_label,parsed_unit(smallest_scale)]
  end

  def axis_values_vertical_stacked_bar
    if percentage
      [0,100]
    else
      series = {}
      allowed_output_element_series.reject{|s|s.is_target}.each_with_index do |serie,i|
        series[i] = [] unless series[i]
        series[i] << Current.gql.query_present(serie.key)
        series[i] << Current.gql.query_future(serie.key)
      end
      all_series = series.each.collect{|x| x.last} unless all_series
      smallest_scale = Metric.scaled_value([all_series.map{|x|[ x.first]}.flatten.sum,all_series.map{|x|[x.last]}.flatten.sum].min,:start_scale => 3).first
      all_series = all_series.map{|x| x.map{|value| Metric.scaled_value(value,:start_scale => 3,:target_scale =>smallest_scale).last}}
      unit = parsed_unit(smallest_scale)
      @all_series_without_targets = all_series
      
      target_result = []
      allowed_output_element_series.select{|s|s.is_target}.each do |serie|
        target_result << Metric.scaled_value(Current.gql.query(serie.key),:start_scale => 3,:target_scale =>smallest_scale).last
      end
      
      total_current = @all_series_without_targets.map{|x| x.first}.sum
      total_future = @all_series_without_targets.map{|x| x.last}.sum
      max_value = ((total_future > total_current) ? total_future : total_current)
      if target_result.flatten.max.andand > max_value
        max_value = target_result.flatten.max
      end
      max_value += (max_value * 0.1)
      [0,axis_scale(max_value)]
    end
  end
  
end
