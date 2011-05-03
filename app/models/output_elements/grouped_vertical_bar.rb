class OutputElement < ActiveRecord::Base

  # TODO refactor: Current.gql.query(serie.key) should only be called once. work with the return values instead (seb 2010-10-11)
  def series_grouped_vertical_bar
    series = {}
    ticks = []
    filler = []   
    
    allowed_output_element_series.reject{|s|s.is_target}.select{|s| s.group == "electricity"}.each_with_index do |serie,i|
      result = Current.gql.query(serie.key)
      series[i] = [] unless series[i]
      series[i] << sanitize_nan(result.present_value)
      series[i] << sanitize_nan(result.future_value)  
      series[i] << 0 unless series[i].length > 2
    end
    ticks << "electricity"
    allowed_output_element_series.reject{|s|s.is_target}.select{|s| s.group == "heat"}.each_with_index do |serie,i|
      result = Current.gql.query(serie.key)
      series[i] = [] unless series[i]
      series[i] << sanitize_nan(result.present_value)
      series[i] << sanitize_nan(result.future_value)      
      series[i] << 0 unless series[i].length > 2
      filler << {}
    end
    
    ticks << "heat"
    series = series.map{|x| x.last}
    
    allowed_output_element_series.select{|s|s.is_target}.each do |serie|
      result = Current.gql.query(serie.key)
      x = serie.position.to_f
      series << [[x - 0.4, result.first], [x + 0.4, result.first]]
    end
      
    [series,ticks,filler,2, unit]
  end

  def sanitize_nan(value)
    value.to_s == 'NaN' ? 0 : value
  end

  def axis_values_grouped_vertical_bar
  
    # if @options.first.fal.min < 0
    #   [axis_scale(@options.first.min * -1) * -1,axis_scale(@options.first.max)]
    # else
      [0,axis_scale(400)]
    # end
  end
end
