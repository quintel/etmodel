# == Schema Information
#
# Table name: slides
#
#  id                    :integer          not null, primary key
#  image                 :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  general_sub_header    :string(255)
#  group_sub_header      :string(255)
#  subheader_image       :string(255)
#  key                   :string(255)
#  position              :integer
#  sidebar_item_id       :integer
#  output_element_id     :integer
#  alt_output_element_id :integer
#

class Slide < ActiveRecord::Base
  include AreaDependent

  belongs_to :sidebar_item
  has_one :description, as: :describable
  has_many :sliders, dependent: :nullify, class_name: 'InputElement'
  belongs_to :output_element # default chart
  belongs_to :alt_output_element, class_name: 'OutputElement' # secondary chart
  has_one :area_dependency, as: :dependable, dependent: :destroy

  validates :key, presence: true, uniqueness: true

  scope :controller, ->(controller) { where(controller_name: controller) }
  scope :ordered,    -> { order('position') }

  accepts_nested_attributes_for :description, :area_dependency

  def image_path
    "/assets/slides/drawings/#{image}" if image.present?
  end

  def title_for_description
    "slides.#{key}"
  end

  def short_name
    I18n.t("slides.#{key}", locale: :en).parameterize
  end

  # See Current.view
  # Some sliders cannot be used on some areas. Let's filter them out
  def safe_input_elements
    @safe_input_elements ||= sliders.includes(:area_dependency)
      .includes(:description).ordered.reject(&:area_dependent)
  end

  # Complementary to grouped_input_elements
  def input_elements_not_belonging_to_a_group
    safe_input_elements.reject(&:belongs_to_a_group?)
  end

  # Gets a interface groups hash with an array of input elements.
  #
  # @return [Hash] interface_group => [InputElement]
  def grouped_input_elements
    interface_groups = {}
    safe_input_elements.select(&:belongs_to_a_group?).each do |i|
      interface_groups[i.interface_group] ||= []
      interface_groups[i.interface_group] << i
    end
    interface_groups
  end

  def short_name_for_admin
    "#{sidebar_item.try :key} : #{key}"
  end

  def url
    "#{sidebar_item.tab.key}/#{sidebar_item.key}/#{short_name}" rescue nil
  end

  def removed_from_interface?
    sidebar_item.nil? || sidebar_item.tab.nil?
  end
end
