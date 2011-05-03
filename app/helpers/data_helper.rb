module DataHelper
  def title_tag_number(value)
    if value.is_a?(Numeric)
      number_with_delimiter value
    end
  end

  def notice_message
    capture_haml do
      if flash[:notice]
        haml_tag '#notice', flash[:notice]
      end
    end
  end

  def result_fields(present, future, attr_name = nil, &block)
    if block_given?
      present_value, future_value = nil, nil
      haml_tag :td do
        present_value = yield(present)
        haml_concat auto_number(present_value)
      end
      haml_tag :td do
        future_value = yield(future)
        haml_concat auto_number(future_value)
      end
      change_field(present_value, future_value)
    else
      present_value = present.send(attr_name)
      future_value  = future.send(attr_name)

      haml_tag :td, auto_number(present_value), :title => title_tag_number(present_value)
      haml_tag :td, auto_number(future_value), :title => title_tag_number(future_value)

      change_field(present_value, future_value)
    end
  end

  def change_field(present_value, future_value)
      haml_tag :'td.change' do
        if future_value == 0.0 and present_value == 0.0
          haml_concat '' 
        else
          haml_concat "#{(((future_value / present_value) - 1) * 100).to_i}%" rescue '-'
        end
      end    
  end
end