# == Schema Information
#
# Table name: slides
#
#  id                 :integer(4)      not null, primary key
#  image              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  general_sub_header :string(255)
#  group_sub_header   :string(255)
#  subheader_image    :string(255)
#  key                :string(255)
#  house_selection    :boolean(1)
#

class Slide < ActiveRecord::Base
  has_paper_trail

  belongs_to :sidebar_item

  has_one :description, :as => :describable
  has_many :input_elements, :dependent => :nullify
  has_one :output_element # default output element
  validates :key, :presence => true, :uniqueness => true
  scope :controller, lambda {|controller| where(:controller_name => controller) }
  scope :ordered, order('position')
  accepts_nested_attributes_for :description

  def search_result
    SearchResult.new(key.humanize, description)
  end

  define_index do
    indexes key
    indexes description(:content_en), :as => :description_content_en
    indexes description(:content_nl), :as => :description_content_nl
    indexes description(:short_content_en), :as => :description_short_content_en
    indexes description(:short_content_nl), :as => :description_short_content_nl
  end

  def image_path
    "/images/layout/#{image}" if image.present?
  end

  def title_for_description
    "slides.#{key}"
  end

  def short_name
    I18n.t("slides.#{key}").parameterize
  end
end
