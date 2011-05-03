class OutputElement < ActiveRecord::Base
  def series_policy_bar
    serie1 = []
    serie2 = []
    ticks = []

    allowed_output_element_series.each do |serie|
      result = Current.gql.query(serie.key)
      present_value = sanitize_nan(result.present_value)
      future_value = sanitize_nan(result.future_value)
      serie1 << present_value
      serie1 << future_value
      serie2 << 100 - present_value
      serie2 << 100 - future_value
    end

    allowed_output_element_series.size.times do
      ticks << [Current.scenario.start_year]
      ticks << [Current.scenario.end_year]
    end
    [serie1,serie2,ticks,allowed_output_element_series.size,unit]
  end

  def sanitize_nan(value)
    value.to_s == 'NaN' ? 0 : value
  end
end
