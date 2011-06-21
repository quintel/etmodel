module LayoutHelpers::SlideHelper
  # I'd rather use common partials - PZ Wed Jun 8 12:41:22 CEST 2011

  def slide_type_in_collection(slide, all_slides)
    case slide
    when all_slides.last
      :last
    when all_slides.first
      :first
    else
      nil
    end
  end

  ##
  # The sub header
  #
  # @param [Slide] slide
  #
  def slide_sub_header(slide)
    return if slide.sub_header.blank?

    haml_tag 'li.sub_header', :id => "sub_header_#{slide.id}" do
      slide_mind_meister_link(slide)
      slide_expert_prediction_link(slide)

      haml_tag :span, t("subheaders.#{slide.sub_header}"), :class=>"subheader_arrow"

      unless slide.subheader_image.blank?
        haml_tag :img, :src => "/images/layout/#{slide.subheader_image}", :class=>"subheader_image"
      end

      haml_tag 'div.clear', ''
    end
  end

  ##
  # Optional link to the mind meister tool.
  #
  # @param [Slide] slide
  #

  def slide_mind_meister_link(slide)
    if slide.id == 25
      haml_tag 'a.mind_meister', t("accordion.mindmeister"),:style => "float:left",
        :href => "http://www.mindmeister.com/maps/show?api_key=aa25bd3be1d339ee02078af0afc80068&auth_token=07d2973007497068&id=86926401&api_sig=sig"
    elsif slide.id == 49
      haml_tag 'a.mind_meister', t("accordion.mindmeister"),:style => "float:left",
        :href => "http://www.mindmeister.com/maps/show?api_key=aa25bd3be1d339ee02078af0afc80068&auth_token=07d2973007497068&id=86926830&api_sig=sig"
    end
    
  end
  
  ##
  # Optional link to the expert prediction tool.
  #
  # @param [Slide] slide
  #
  def slide_expert_prediction_link(slide)
    if slide.show_expert_prediction_link
      haml_tag 'a.expert_header', t("accordion.expert predictions available"),:style => "float:left",
        :href => "/expert_predictions?slide_id=#{slide.id}" 
    end
  end

  def render_interface_group(group, title = nil)
    haml_tag 'li.interface_group' do
      haml_tag :span, t("accordion.#{group[0]}"), :style =>"float:left"
      unless title.blank?
        haml_tag :span, t("subheaders.#{title}"), :class =>"subheader_arrow"
      end
    end
    group.last.each do |input_element|
     haml_concat(render :partial => 'input_elements/slider', :object => input_element)
    end  
  end
  
  def render_input_element_javascript_create(input_elements)
    haml_tag :script, input_elements.map{ |ip|  create_input_element(ip) }.join("\n").html_safe
  end
  
  
  def render_input_element_javascript_update(input_elements)
    haml_tag :script, input_elements.map{ |ip|  update_input_element(ip) }.join("\n").html_safe
  end
  
end