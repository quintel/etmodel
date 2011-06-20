class Interface < ActiveRecord::Base
  has_paper_trail
  
  validates :key, :presence => true
  validates :key, :uniqueness => true
  
  attr_accessible :key, :enabled, :structure
  
  def tabs
    tree.keys.map{|k| Tab.find_by_key(k)} rescue []
  end
  
  def tree
    @tree ||= YAML.load(structure)
  end
  
  def sidebar_items_for(tab_key)
    tree[tab_key].keys.map{|k| SidebarItem.find_by_key(k)} rescue []
  end
  
  def slides_for(tab_key, sidebar_item_key)
    tree[tab_key][sidebar_item_key].keys.map{|k| Slide.find_by_key(k)} rescue []
  end
  
  def input_elements_for(tab_key, sidebar_item_key, slide_key)
    tree[tab_key][sidebar_item_key][slide_key][:input_elements].map{|k| InputElement.find_by_key(k)} rescue []
  end
  
  def output_elements_for(tab_key, sidebar_item_key, slide_key)
    tree[tab_key][sidebar_item_key][slide_key][:output_elements].map{|k| OutputElement.find_by_key(k)} rescue []
  end
  
  def default_chart_for_slide(slide_key)
    OutputElement.find(Slide.find_by_key(slide_key).default_output_element_id) rescue nil
  end
end
