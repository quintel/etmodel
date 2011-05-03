module JavascriptHelper

  # Convert an Array of objects/values to a javascript parameter list
  #
  # e.g. 
  #   js_params [12, 'foo', nil]
  #   => "12, 'foo', null" 
  # 
  # @param [Array]
  # @return [String]
  #
  def js_params(params)
    [params].flatten.map do |param|
      param.nil? ? 'null' : param.inspect
    end.join(', ')
  end
  
  def init_etm_javascript_framework

  end

  def create_input_element(input_element)
    "window.input_elements.add(%s.input_element);" % [input_element.to_json]
  end
  
  def update_input_element(input_element)
    script = "var a = App.inputElementsController.get('%s');" % input_element.id
    script << "if(a) a.set(%s.input_element); else console.log('Updating input element with id: %s, but not on page');" % [input_element.to_json, input_element.id]
    script.html_safe
  end
  
  
  def update_constraint(constraint)
    ''
  end



end