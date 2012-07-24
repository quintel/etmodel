# == Schema Information
#
# Table name: slides
#
#  id                    :integer(4)      not null, primary key
#  image                 :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  general_sub_header    :string(255)
#  group_sub_header      :string(255)
#  subheader_image       :string(255)
#  key                   :string(255)
#  position              :integer(4)
#  sidebar_item_id       :integer(4)
#  output_element_id     :integer(4)
#  alt_output_element_id :integer(4)
#

class Slide < ActiveRecord::Base
  has_paper_trail

  belongs_to :sidebar_item

  has_one :description, :as => :describable
  has_many :sliders, :through => :slider_positions
  has_many :slider_positions, :dependent => :destroy, :order => 'slider_positions.position'
  belongs_to :output_element # default chart
  belongs_to :alt_output_element, :class_name => 'OutputElement' # secondary chart
  validates :key, :presence => true, :uniqueness => true
  scope :controller, lambda {|controller| where(:controller_name => controller) }
  scope :ordered, order('position')
  accepts_nested_attributes_for :description
  accepts_nested_attributes_for :slider_positions,
    :allow_destroy => true,
    :reject_if => proc {|attributes| attributes['slider_id'].blank? }

  searchable do
    string :key
    text :name_en, :boost => 5 do
      I18n.t("slides.#{key}", :locale => :en)
    end
    text :name_nl, :boost => 5 do
      I18n.t("slides.#{key}", :locale => :nl)
    end

    text :content_en do
      description.try :content_en
    end
    text :content_nl do
      description.try :content_nl
    end
    text :short_content_en do
      description.try :short_content_en
    end
    text :short_content_nl do
      description.try :short_content_nl
    end
  end

  def image_path
    "/assets/slides/drawings/#{image}" if image.present?
  end

  def title_for_description
    "slides.#{key}"
  end

  def short_name
    I18n.t("slides.#{key}").parameterize
  end

  # See Current.view
  # Some sliders cannot be used on some areas. Let's filter them out
  def safe_input_elements
    @safe_input_elements ||= sliders.ordered.reject(&:area_dependent)
  end

  # Complementary to grouped_input_elements
  def input_elements_not_belonging_to_a_group
    safe_input_elements.reject &:belongs_to_a_group?
  end

  # Gets a interface groups hash with an array of input elements.
  #
  # @return [Hash] interface_group => [InputElement]
  def grouped_input_elements
    interface_groups = {}
    items = safe_input_elements.select &:belongs_to_a_group?
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
