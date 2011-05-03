module LayoutHelpers::InputElementHelper
  include UserLogicHelper
  
  def slider(input_element)
    input_element_id = dom_id(input_element)
    
    # TODO seb why do we need the share_group in the id? when input_element.id is already unique.
    #          if needed in javascript, use :"data-share_group" => input_element.share_group instead
    haml_tag :div, :id => "slider-group-%s-%s" % [input_element.share_group, input_element.id] do
      haml_tag :div, :id => input_element_id do
        slider_name_box(input_element)
        slider_info_box(input_element)
      end
    end
    # haml_tag :script do
      # haml_concat "App.inputElementsController.addInputElement(new InputElement(%s.input_element), {'element':$('#%s')});" % [input_element.to_json, input_element_id]
    # end
  end

  def slider_name_box(input_element)
    haml_tag 'div.name' do
      haml_tag 'div.text', input_element.translated_name.html_safe
      haml_tag 'div.label', input_element.parsed_label
      
    end
  end

  
  def slider_info_box(input_element)
    haml_tag 'div.info-box' do
      # begin
        haml_tag 'div.text', input_element.parsed_description
      # rescue
        # raise input_element.description.content.inspect
      # end
    end
  end
  

    
  
end