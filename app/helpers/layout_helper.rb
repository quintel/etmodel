module LayoutHelper
  
  def title(str)
    haml_tag :h2, str
  end

  def title_text
    if title = PageTitle.for_page(controller.controller_name, params[:id]).first
      haml_tag :h2, I18n.t("pagetitle.#{title.title}").html_safe
      haml_tag 'p#content_short.visible' do
        haml_tag :span, truncate(title.description.andand.short_content.html_safe, :length => 135).html_safe
        haml_tag 'a#read_more', I18n.t("pagetitle.readmore"), :href => "#"
      end

      haml_tag "p#content_long.hidden" do
        haml_tag :span, title.description.andand.content.force_encoding("UTF-8").html_safe

        haml_tag "a#read_less", I18n.t("pagetitle.hidetext"), :href => "#"
      end
    end
  end
  
  # splits the collection in two and adds a read more link if 
  # the collection.length > limit
  # takes a block that yields all elements of the collection
  #
  def readable_collection(collection, limit, &block)
    first_half = collection[0..limit]
    second_half = collection[limit..collection.length]
    first_half.each do |item|
      yield item
    end
    
    unless second_half.blank?
      # generate a unique id
      collection_id = "readable_collection_" + (Kernel.rand * 100000).to_i.to_s 
      haml_tag :a, t('show_more'), :href => "javascript:$('##{collection_id}').toggle()", :style => 'display:block'
      haml_tag :div, :id => collection_id, :style => 'display:none' do
        second_half.each do |item|
          yield item
        end
      end
    end
  end

  # TODO move controller_name logic to Tab
  def tab(title, controller_name = title, action_name = nil)
    class_name = (controller.controller_name == controller_name) ? 'active' : nil
    if action_name.nil?
      link = "/#{controller_name}"
    else
      link = (controller_name == "") ? '/' : "/#{controller_name}/#{action_name}"
    end
    haml_tag :li, :class => class_name, :id => title.downcase do
      haml_tag :a, I18n.t(title.capitalize), :href => link
    end
  end

  def goal_reached(policy)
    if policy.reached?
      "<span style=\"color:green\">V</span>".html_safe
    else
      "<span style=\"color:red\">X</span>".html_safe
    end
  end
  
  def search_result_description(result)
    if d = result.andand.description
      if d.content.present?
        "#{strip_html d.content[0..160]}...".html_safe
      end
    end
  end

  def back_to_model_link
    link_to t("back to model"), :controller => Current.setting.last_etm_controller_name, :action => session[:last_etm_action_name] unless Current.setting.last_etm_controller_name.blank?
  end
  
  
  def shadowbox(&block)
    haml_tag :div, :id => "shadowbox-outer", :style => "width: 70%; margin: 10px 0px 40px 15%;" do
      ['n', 'ne', 'e', 'se', 's', 'sw', 'w', 'nw'].each do |dir|
        haml_tag :div, :id => "shadow-bg-%s" % dir, :class => "shadow-bg"
      end
      
      haml_tag :div, :id => "shadowbox-inner", :style => "padding: 20px 40px 40px 40px;" do
        haml_tag :div, :id => "shadowbox-content", :style => "width: 100%; float:none;" do
          yield
        end
      end
    end
  end
  
  def rounded_corners
    haml_tag :div, :class => "rounded_corners" do
      haml_tag :div, :class => "right_corner"
      haml_tag :div, :class => "left_corner"
      haml_tag :div, :class => "spacer"
    end
    
  end
  
  def current_tutorial_movie
    SidebarItem.find_by_key(params[:id]).andand.send("#{I18n.locale}_vimeo_id")
  end
end
