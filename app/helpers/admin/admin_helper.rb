module Admin::AdminHelper

  def demand_value(converter_qernel)
    demand, expected = converter_qernel.query.demand, converter_qernel.query.demand_expected_value

    if converter_qernel.query.demand_expected? == false
      haml_tag :span, "&#x2639;".html_safe
      haml_tag :small, "(#{number_with_precision(expected, :precision => 1, :delimiter => "'")})"
    elsif converter_qernel.query.demand_expected? == true
      haml_tag :span, "&#x263A;".html_safe
    end

    haml_tag :span, number_with_precision(demand, :precision => 1, :delimiter => "'")
  end

end