module OutputElementsHelper
  def output_element_serie(serie)
    str = "output_element.series.add({ "
    str += "gquery_key : #{serie.key.inspect}, "
    str += "color : #{serie.converted_color.inspect}, "
    str += "label : #{serie.title_translated.inspect} "    
    str += "});"
    str.html_safe
  end
end