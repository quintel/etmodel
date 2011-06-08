module LayoutHelpers::SlideHelper
  # I'd rather use common partials - PZ Wed Jun 8 12:41:22 CEST 2011

  # move this to slide!
  def slide_image_path(slide)
    "/images/layout/#{slide.image}" if slide.image.present?
  end

  def slides
    slides = Current.view.slides
    if slides.present?
      @output_element = Current.view.default_output_element_for(slides.first)
      haml_tag 'div#accordion_wrapper' do
        haml_tag 'ul.accordion' do
          slides.each do |slide|
            
            slides_dependent_on = "slides-%s" % [slide.id, I18n.locale, Current.setting.region_or_country, Current.setting.complexity].join("-")

            type = slide_type_in_collection(slide, slides)
            accordion_slide(slide, type)

            # this is uncached!
            render_input_element_javascript_create(Current.view.input_elements_for(slide))
          end
        end
      end
    else
      haml_tag 'div#accordion_wrapper', t("not_available")
    end
    
    if Current.current_slide
      haml_tag :script do
        haml_concat "active_slide = '#{Current.current_slide}'"
      end
    end 
    
  end

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


  # FIXME: add extra parameter 'key' instead of abusing the title in find_by_name.
  # this key could be used for many things (translating, descriptions)
  # e.g.: accordion_slide(title, key, options = {}, &block)
  #
  # QUESTIONS: (DS 2010-10-26)
  #   - What is interface group?
  # TODO: (DS 2010-10-26)
  #   - Move all the CSS to SASS
  #   - Cut this to nice pieces, its way too long and reads very difficult. Probably we can delete a lot of excess HTML right?
  def accordion_slide(slide, slide_type = nil)
    selected = ' selected' if ((params[:slide] and params[:slide] == slide.name) or slide_type == :first)

    haml_tag 'li.accordion_element', :class => selected do 
      slide_header(slide)

      haml_tag 'div.slide' do
        slide_info_block(slide)
        
        haml_tag 'ul.valuees' do
          slide_sub_header(slide)

          Current.view.ungrouped_input_elements_for(slide).each do |input_element|
            slider(input_element)
          end

          Current.view.interface_groups_with_input_elements_for(slide).each do |group|
            render_interface_group(group, slide.sub_header2)
          end
        end

        next_slide_button unless slide_type == :last
      end
    end
    
  end

  ##
  # The slide header is the blue part you can click on when the slide is minimized.
  #
  # @param [Slide] slide
  #
  def slide_header(slide)
    
    default_output = Current.view.default_output_element_for(slide)
    haml_tag 'span.headline', :id => "default_output_#{default_output.id}", :slide => slide.id do
      haml_tag 'a.slide_header', t("slidetitle.#{slide.name}").html_safe,
        :href => "/#{controller_name}/#{params[:id]}/#{slide.name.underscore}", :id => slide.name.underscore
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
  # The slide_info_block is the part just below the slide_header that has a picture
  # and some info text.
  #
  # @param [Slide] slide
  #
  def slide_info_block(slide)
    haml_tag :p do
      haml_tag :img, :src => slide_image_path(slide) if slide.image.present?

      haml_concat slide.description.andand.content.andand.html_safe

      slide_optional_house_selection_link(slide)
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
  ##
  # Optional link to the house selection tool.
  #
  # @param [Slide] slide
  #
  def slide_optional_house_selection_link(slide)
    if slide.show_house_selection_tool
      haml_tag 'a.house_selection_tool', t("accordion.help me choose"), :href => house_selection_tool_path
    end
  end

  ##
  # Link to jump to next slide
  #
  def next_slide_button
    haml_tag 'a.btn-done.next', I18n.t("go to next"), :href => "#"
  end

  def render_interface_group(group, title = nil)
    haml_tag 'li.interface_group' do
      haml_tag :span, t("accordion.#{group[0]}"), :style =>"float:left"
      unless title.blank?
        haml_tag :span, t("subheaders.#{title}"), :class =>"subheader_arrow"
      end
    end
    group.last.each do |input_element|
      slider(input_element)
    end  
  end
  
  def render_input_element_javascript_create(input_elements)
    haml_tag :script, input_elements.map{ |ip|  create_input_element(ip) }.join("\n").html_safe
  end
  
  
  def render_input_element_javascript_update(input_elements)
    haml_tag :script, input_elements.map{ |ip|  update_input_element(ip) }.join("\n").html_safe
  end
  
end