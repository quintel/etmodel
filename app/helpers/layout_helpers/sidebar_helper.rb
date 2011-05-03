module LayoutHelpers::SidebarHelper
  def generate_sidebar_item(item, options = {})
     haml_tag :li, :id => item.key, :class => (params[:id] == item.key) ? 'active' : nil do
       link_with_icon(item)
     end
   end

   def link_with_icon(item)
     haml_tag :a, :class => "ico-#{item.key}", :href => url_for(:action => item.key) do
       sidebar_item_spacer
       haml_tag :p do
         haml_tag :span, I18n.t("sidebar_item.#{item.key}").html_safe,:class => "title"
         #unless item.percentage_bar_query.blank?
         #  percentage = (Current.gql.query(item.percentage_bar_query) * 100).round(0).to_i
         #  percentage_bar(percentage,item.key)
         #end
       end
     end
   end
   
   def sidebar_item_spacer
     haml_tag :em, "&nbsp;".html_safe
   end
   
   def percentage_bar(percentage,key)
     scale_factor = 0.7
     haml_tag :span, "&nbsp;".html_safe, :class =>"#{key}_in", :style => "width: #{(percentage*scale_factor)}px"
     haml_tag :small, "#{percentage}%".html_safe
   end
end