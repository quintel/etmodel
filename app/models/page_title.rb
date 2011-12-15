# == Schema Information
#
# Table name: page_titles
#
#  id         :integer(4)      not null, primary key
#  controller :string(255)
#  action     :string(255)
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# TODO: get rid of this object, use standard description class
# Remember to update the search engine index!
class PageTitle < ActiveRecord::Base
  has_paper_trail

  has_one :description, :as => :describable

  scope :for_page, lambda {|controller, action| where(:controller => controller, :action => action).limit(1) }

  def search_result
    SearchResult.new(title, description.andand.short_content)
  end


  define_index do
    indexes title
    indexes description(:content_en), :as => :description_content_en
    indexes description(:content_nl), :as => :description_content_nl
    indexes description(:short_content_en), :as => :description_short_content_en
    indexes description(:short_content_nl), :as => :description_short_content_nl
  end
end
