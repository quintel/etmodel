class OutputElement < ActiveRecord::Base

  def series_waterfall
    series = []

    allowed_output_element_series.each do |serie|
      if serie.group == 'value'
        series << Current.gql.query("#{serie.key}")
      else
        result = Current.gql.query("#{serie.key}")
        now = result.first.last
        future = result.last.last
        diff = future - now
        series << diff
      end
    end
    start_scale = 3
    
    # TODO: make all series start at lowest scale
    if id == 61
      start_scale = 2 
    end
    summed_scale = Metric.scaled_value(series.sum,:start_scale => start_scale).first
    max_scale = Metric.scaled_value(series.max,:start_scale => start_scale).first
    scale = summed_scale > max_scale ? summed_scale : max_scale # this fixes the scaling when really small an d really large numbers are present
    series = series.map{|value| Metric.scaled_value(value,:start_scale => start_scale, :target_scale =>scale).last}
    unit = parsed_unit(scale)
    [series,unit]
  end

  def colors_waterfall
    colors = allowed_output_element_series.map do |serie|
      convert_color(serie.color)
    end
    colors << convert_color(allowed_output_element_series.first.color)
    colors
  end

  def labels_waterfall
    labels = allowed_output_element_series.map do |serie|
      I18n.t("serie.#{serie.label}")
      # serie.label.to_s
    end
    if id == 51
      labels << "#{Current.scenario.end_year}"
    else
      labels << "Total" # add completing label
    end
    labels
  end

  def axis_values_waterfall
    total = @options.first

    neg = (total.map{|x| (x < 0) ? x : 0 }.sum)
    # logger.info "neg #{neg}"
    neg = axis_scale(neg * -1) *-1 unless neg == 0
    pos = total.map{|x| (x > 0) ? x : 0 }.sum
    [ neg , axis_scale(pos)]
  end
end
