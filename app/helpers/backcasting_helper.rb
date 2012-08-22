module BackcastingHelper
  def describe_prediction(p)
    value = "%.1f" % p.corresponding_slider_value rescue nil
    slider = p.input_element
    if @end_year
      if ['growth_rate', 'efficiency_improvement'].include?(slider.command_type)
        "#{value}#{slider.unit} #{I18n.t('prediction.per_year')}"
      else
        "#{value}#{slider.unit}"
      end
    else
      "#{value}#{slider.unit}"
    end
  end
  
  def describe_user_value(slider)

    if @end_year && ['growth_rate', 'efficiency_improvement'].include?(slider.command_type)
      "#{I18n.t('prediction.per_year')}"
    end
  end
  
  def parenthesize( string )
    return '' if string.blank?
    "(#{string})" 
  end
end