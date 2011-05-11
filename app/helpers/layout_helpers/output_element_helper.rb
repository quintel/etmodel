module LayoutHelpers::OutputElementHelper
  # TODO rob (2010-08-20) rename "a" to a more explanatory name
  def intro_charts_item(title, a, options = {})
    value, percent, scale_factor = 0, 0, 5
    options[:total] = 0
    if options[:query] and total = options[:total] and total != 0.0
      value = 0 #Current.gql.query(options[:query])
      percent = ((value / total) * 100).to_i
    end
    height = percent * scale_factor

    class_name = (params[:action] == a) ? "active " : ''
    class_name += title.downcase

    haml_tag :li, :style =>"height:#{height}px", :class => class_name do
      haml_tag :a, t("#{title}"), :href => ( options[:clickable] ? url_for(:action => a) : "#" )
      haml_tag 'div.number', "#{(value / BILLIONS).round(1)} PJ"
      haml_tag 'div.percentage', "#{percent}%"
    end
  end

  # TODO: refactor, use standard partials and keep things simple
  def charts
    return unless @output_element

    Current.scenario.selected_output_element = nil
    Current.scenario.displayed_output_element = @output_element.id
    haml_tag 'div#charts_wrapper' do
      haml_tag 'div#charts_holder' do
        if @output_element.block_chart?
          concat "BLOCK CHART ELEMENT"
          # TODO: reimplement - PZ Wed 11 May 2011 15:20:42 CEST
          # @blocks = @output_element.allowed_output_element_series
          # haml_concat render "layouts/etm/cost_output_element"
        else
          haml_concat render "layouts/etm/output_element"
        end
      end
    end
  end

  def add_output_element_js(output_element)
    #javascript_tag("ETM.outputElementsController.addOutputElement(new OutputElement(#{output_element.to_json}.output_element), {'element':$('#charts_container')})")
  end
  
  def displayed_output_element_is_default?
    Current.scenario.selected_output_element.nil?
  end
end