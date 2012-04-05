module OutputElementsHelper
  def output_element_serie(serie)
    s = {
      :id         => serie.id, # needed for block charts
      :gquery_key => serie.gquery,
      :color      => serie.color,
      :label      => serie.title_translated,
      :group      => serie.group, #used to group series
      :group_translated => serie.group_translated, # used to display groups in mekkos's & horizontal_stacked_bar
      :is_target_line  => serie.is_target_line,
      :target_line_position   => serie.target_line_position
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

  # Some charts need custom HTML. This method returns it
  # as a JS-safe string
  # See app/views/admin/output_elements/show.html.haml
  # app/views/output_elements/show.js.erb
  def js_render_chart(chart)
    template = if chart.html_table?
      "output_elements/tables/chart_#{chart.id}"
    else
      "output_elements/block_chart"
    end
    escape_javascript(render template)
  end
end
