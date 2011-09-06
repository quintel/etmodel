# == Schema Information
#
# Table name: slides
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  image           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  sub_header      :string(255)
#  sub_header2     :string(255)
#  subheader_image :string(255)
#  key             :string(255)
#  house_selection :boolean(1)
#

class Slide < ActiveRecord::Base
  has_paper_trail

  has_one :description, :as => :describable
  validates :key, :presence => true, :uniqueness => true
  scope :controller, lambda {|controller| where(:controller_name => controller) }
  accepts_nested_attributes_for :description

  def search_result
    SearchResult.new(name, description)
  end

  define_index do
    indexes name
    indexes description(:content_en), :as => :description_content_en
    indexes description(:content_nl), :as => :description_content_nl
    indexes description(:short_content_en), :as => :description_short_content_en
    indexes description(:short_content_nl), :as => :description_short_content_nl
  end

  def parsed_name_for_admin
    "#{action_name.andand[0..30]} | #{name}"
  end
  
  def image_path
    "/images/layout/#{image}" if image.present? 
  end

  def title_for_description
    "slidetitle.#{name}"
  end

end
