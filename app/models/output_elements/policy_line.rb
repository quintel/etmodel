class OutputElement < ActiveRecord::Base
  def series_policy_line
    series = []
    allowed_output_element_series.each do |serie|
      if serie.historic_key
        historic_result = Current.gql.query_historic(serie.historic_key)
        series << historic_result if historic_result
      end
      if serie.expert_key and ep = ExpertPrediction.find_by_key(serie.expert_key)
        series << ep.year_values.map{|x|[x.year,(( 1 + (x.value / 100)) * Current.gql.query(serie.key))]}
      else
        result = Current.gql.query(serie.key)
        series << [result.first, result.last]
      end
    end
    
    if unit == "MT"
      start_scale = 2
    else
      start_scale = 3
    end
    smallest_scale = Metric.scaled_value([series.map{|present,future|[ present.last.abs]}.flatten.sum,series.map{|present,future|[ future.last.abs]}.flatten.sum].min,:start_scale => start_scale).first

    
    series = series.map{|x| x.map{|year,value| [year,Metric.scaled_value(value,:start_scale => start_scale,:target_scale =>smallest_scale).last]}}
    unit = parsed_unit(smallest_scale)
    
    [series,unit]
  end

  def colors_policy_line
    colors = []
    allowed_output_element_series.each do |serie|
      colors << convert_color(serie.color)
      colors.unshift(convert_color("coal_black")) if check_for_historic(serie)
    end
    colors
  end

  def labels_policy_line
    labels = []
    allowed_output_element_series.map do |serie|
      labels << I18n.t("serie.#{serie.label}")
      labels.unshift(I18n.t("serie.historic")) if check_for_historic(serie)
    end
    labels
  end

  def axis_values_policy_line
    [0,axis_scale(@options.first.last.map(&:last).max)]
  end

  def check_for_historic(serie)
    if serie.historic_key
      historic_result = Current.gql.query_historic(serie.historic_key)
      historic_result.present?
    else
      false
    end
  end
end
