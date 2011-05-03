class OutputElement < ActiveRecord::Base

  def series_vertical_bar
    series = {}
    targets = []
    ticks = []
    filler = []

    allowed_output_element_series.reject{|s|s.is_target}.each_with_index do |serie,i|
      series[1] = [] unless series[1]
      if serie.group == 'historic'
        series[1] << Current.gql.query_present(serie.key)
        ticks << 1990
        # filler << {}
      else
        series[1] << Current.gql.query_present(serie.key)
        series[1] << Current.gql.query_future(serie.key)
        filler << {}
      end
    end


    all_series = series.each.collect{|x| x.last} unless all_series
    unless percentage
      smallest_scale = Metric.scaled_value([all_series.map{|x|[ x.first]}.flatten.sum,all_series.map{|x|[x.last]}.flatten.sum].min,:start_scale => 2).first
      all_series = all_series.map{|x| x.map{|value| Metric.scaled_value(value,:start_scale => 2,:target_scale =>smallest_scale).last}}
      @all_series_without_targets = all_series
    end

    allowed_output_element_series.select{|s|s.is_target}.each do |serie|
      # this shoiuld be in the query
      if serie.group == 'policy'
        result = Current.gql.query(serie.key).last.last # * @all_series.first.first) + @all_series.first.first
      end
      x = serie.position.to_f
      all_series << [[x - 0.4, Metric.scaled_value(result,:start_scale => 2,:target_scale =>smallest_scale).last], [x + 0.4, Metric.scaled_value(result,:start_scale => 2,:target_scale =>smallest_scale).last]]
    end

    ticks << Current.scenario.start_year
    ticks << Current.scenario.end_year

    [all_series,ticks,filler,show_point_label,parsed_unit(smallest_scale)]
  end

  def axis_values_vertical_bar
    [0,axis_scale(@options.first.flatten.max)]
  end

  def colors_vertical_bar
    colors = []
    colors << convert_color(allowed_output_element_series.first.color)
    allowed_output_element_series.select{|s|s.is_target}.each do |serie|
      colors << convert_color(serie.color)
    end
    colors
  end

end
