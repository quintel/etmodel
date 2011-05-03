class OutputElement < ActiveRecord::Base

  def series_mekko
    series = {}
    total = 0
    allowed_output_element_series.each do |serie|
      series[serie.group] = [] unless series[serie.group]
      result = Current.gql.query("#{serie.key}")
      total += result
      series[serie.group] << result
    end
    start_scale = 3
    series = series.each.collect{|x| x.last}
    smallest_scale = Metric.scaled_value(series.flatten.sum,:start_scale => start_scale).first



    series =  series.map{|sector| sector.map{|v| Metric.scaled_value(v,:start_scale => start_scale, :target_scale =>smallest_scale).last}}
    unit = parsed_unit(smallest_scale)
    [series,unit]
  end

  def colors_mekko
    allowed_output_element_series.map do |serie|
      convert_color(serie.color)
    end.uniq
  end

  def labels_mekko
    original_labels = []
    labels = []
    original_labels << allowed_output_element_series.map do |serie|
      serie.label
    end.uniq

    labels << allowed_output_element_series.map do |serie|
      #force it into a string, to prevent weird caching things
      "#{I18n.t("serie.#{serie.label}")}"
    end.uniq

    groups = allowed_output_element_series.map do |serie|
      "#{I18n.t("serie.#{serie.group}").to_s }"
      # serie.group
    end.uniq

    total = 0

    original_labels.first.each do |label|
      # "labels op een hoop: #{label}: #{OutputElementSerie.find_all_by_label_and_output_element_id(label,id)}"
      value = OutputElementSerie.find_all_by_label_and_output_element_id(label,id).map do |serie|
        Current.gql.query("#{serie.key}")
      end.flatten.sum

      total += value
    end

    original_labels.first.each_with_index do |label,i|
      value = OutputElementSerie.find_all_by_label_and_output_element_id(label,id).map do |serie|
        Current.gql.query("#{serie.key}")
      end.flatten.sum
      # % as postfix
      # labels.first[i] = ((value / total)*100).round(1).to_s + "%&nbsp; #{labels.first[i]}"
      # % as suffix
      total = 1 if total == 0
      labels.first[i] << "&nbsp; " + ((value / total)*100).round(1).to_s + "%"
    end

    labels << groups
    labels
  end

  def axis_values_mekko
    total = allowed_output_element_series.map do |serie|
      Current.gql.query(serie.key)
    end.sum

    [0, axis_scale(total)]
  end

end
