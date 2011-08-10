module OutputElementsHelper
  def output_element_serie(serie)
    s = {      
      :id         => serie.id, # needed for block charts
      :gquery_key => gquery_id(serie.gquery).to_s,
      :color      => serie.converted_color,
      :label      => serie.title_translated,
      :group      => serie.group,
      :is_target  => serie.is_target,
      :position   => serie.position
    }

    "output_element.series.add(#{s.to_json});"
  end
  
  # Used in the constraint popups
  def js_for_output_element(id, dom_id)
    element = OutputElement.find(id) rescue nil
    return unless element
    
    chart_options = element.options_for_js.merge(:container => dom_id).to_json
    series_options = element.allowed_output_element_series.map{|s| output_element_serie(s)}.join
    
    out = <<EOJS
    
    var output_element = new Chart(#{chart_options});
    #{series_options}
    charts.add(output_element);
    
EOJS
    out.html_safe
  end
end