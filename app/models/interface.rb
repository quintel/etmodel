# == Schema Information
#
# Table name: interfaces
#
#  id         :integer(4)      not null, primary key
#  key        :string(255)
#  structure  :text
#  enabled    :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class Interface < ActiveRecord::Base
  has_paper_trail
  
  validates :key, :presence => true
  validates :key, :uniqueness => true
  
  attr_accessible :key, :enabled, :structure
  
  def tabs
    tree[:tabs].keys.map{|k| Tab.find_by_key(k)} rescue []
  end
  
  def tree
    @tree ||= YAML.load(structure)
  end
  
  def sidebar_items_for(tab_key)
    tree[:tabs][tab_key].keys.map{|k| SidebarItem.find_by_key(k)}.
    reject(&:area_dependent) rescue []
  end
  
  def slides_for(tab_key, sidebar_item_key)
    tree[:tabs][tab_key][sidebar_item_key].keys.map{|k| Slide.find_by_key(k)}
    rescue []
  end
  
  def input_elements_for(tab_key, sidebar_item_key, slide_key)
    tree[:tabs][tab_key][sidebar_item_key][slide_key][:input_elements].map{|k| InputElement.find_by_key(k)}.
      reject(&:area_dependent) rescue []
  end
  
  def output_elements_for(tab_key, sidebar_item_key, slide_key)
    tree[:tabs][tab_key][sidebar_item_key][slide_key][:output_elements].map{|k| OutputElement.find_by_key(k)}.
      reject(&:area_dependent) rescue []
  end
  
  def default_chart_for_slide(tab_key, sidebar_item_key, slide_key)
    key = tree[:tabs][tab_key][sidebar_item_key][slide_key][:output_elements].first
    OutputElement.find_by_key(key) rescue nil
  end
  
  def default_chart_for_sidebar_item(tab_key, sidebar_item_key)
    slide_key = slides_for(tab_key, sidebar_item_key).first.key
    default_chart_for_slide(tab_key, sidebar_item_key, slide_key)
  end
  
  def constraints
    @contraints ||= Constraint.for_dashboard(tree[:dashboard]) rescue []
  end
  
  def policy_goals
    @policy_goals ||= tree[:policy_goals].map{|x| PolicyGoal.find_by_key(x)} rescue []
  end
  
  def allowed_policy_goals
    @allowed_policy_goals ||= policy_goals.reject(&:area_dependent) rescue []
  end
end
