module JavascriptHelper
  
  def create_input_element(input_element)
    "window.input_elements.add(%s.input_element);" % [input_element.to_json]
  end
  
  def update_input_element(input_element)
    script = "var a = App.inputElementsController.get('%s');" % input_element.id
    script << "if(a) a.set(%s.input_element); else console.log('Updating input element with id: %s, but not on page');" % [input_element.to_json, input_element.id]
    script.html_safe
  end
end