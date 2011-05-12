module OutputElementsHelper
  def output_element_serie(serie)
    s = {      
      :gquery_key => serie.gquery, # New column!
      :color      => serie.converted_color,
      :label      => serie.title_translated,
      :group      => serie.group
    }

    "output_element.series.add(#{s.to_json})"
  end
end