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
#  position           :integer(4)
#  sidebar_item_id    :integer(4)
#  output_element_id  :integer(4)
#

class Slide < ActiveRecord::Base
  has_paper_trail

  belongs_to :sidebar_item

  has_one :description, :as => :describable
  has_many :sliders, :through => :slider_positions
  has_many :slider_positions, :dependent => :destroy, :order => 'slider_positions.position'
  belongs_to :output_element # default output element
  validates :key, :presence => true, :uniqueness => true
  scope :controller, lambda {|controller| where(:controller_name => controller) }
  scope :ordered, order('position')
  accepts_nested_attributes_for :description
  accepts_nested_attributes_for :slider_positions,
    :allow_destroy => true,
    :reject_if => proc {|attributes| attributes['slider_id'].blank? }

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
    "/assets/layout/#{image}" if image.present?
  end

  def title_for_description
    "slides.#{key}"
  end

  def short_name
    I18n.t("slides.#{key}").parameterize
  end

  # See Current.view
  def input_elements
    @safe_input_elements ||= sliders.ordered
  end

  # Complementary to grouped_input_elements
  def input_elements_not_belonging_to_a_group
    input_elements.reject &:belongs_to_a_group?
  end

  # Gets a interface groups hash with an array of input elements.
  #
  # @return [Hash] interface_group => [InputElement]
  def grouped_input_elements
    interface_groups = {}
    items = input_elements.select &:belongs_to_a_group?
    items.each do |i|
      interface_groups[i.interface_group] ||= []
      interface_groups[i.interface_group] << i
    end
    interface_groups
  end

  def short_name_for_admin
    "#{sidebar_item.try :key} : #{key}"
  end

  def url
    "/#{sidebar_item.tab.key}/#{sidebar_item.key}##{short_name}" rescue nil
  end
end
