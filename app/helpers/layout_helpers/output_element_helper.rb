module LayoutHelpers::OutputElementHelper
  # TODO: refactor, use standard partials and keep things simple
  def charts
    return unless @output_element

    Current.setting.selected_output_element = nil
    Current.setting.displayed_output_element = @output_element.id
    haml_tag 'div#charts_wrapper' do
      haml_tag 'div#charts_holder' do
        if @output_element.block_chart?
          @blocks = @output_element.allowed_output_element_series
          haml_concat render "layouts/etm/cost_output_element"
        else
          haml_concat render "layouts/etm/output_element"
        end
      end
    end
  end

  def displayed_output_element_is_default?
    Current.setting.selected_output_element.nil?
  end
end