# frozen_string_literal: true

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

# This model represents a slide within an opened SideBarItem
# (e.g. "Insulation", "Cooking", for "Households" item)
class Slide < YModel::Base
  include AreaDependent::YModel

  has_one :description, as: :describable
  has_many :input_elements
  alias_method :sliders, :input_elements
  belongs_to :output_element # default chart
  belongs_to :alt_output_element, class_name: 'OutputElement' # secondary chart

  class << self
    def controller(controller)
      where(controller_name: controller)
    end

    def ordered
      visible.sort_by(&:position)
    end

    def visible
      all.reject { |s| s.position.nil? }
    end
  end

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
    @safe_input_elements ||= sliders.reject(&:area_dependent)
      .sort_by(&:position)
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
    url_components.join('/')
  end

  # Allows the slide to be used as an argument to play_url to link directly to
  # the correct page.
  #
  # For example:
  #
  #   play_url(*slide.url_components)
  def url_components
    tab ? [tab.key, sidebar_item.key, short_name] : []
  end

  def sidebar_item
    SidebarItem.find(sidebar_item_id)
  end

  def sidebar_item=(sidebar_item)
    self.sidebar_item_id = sidebar_item&.id
  end

  def tab
    sidebar_item&.tab
  end

  def removed_from_interface?
    sidebar_item.nil? || sidebar_item.tab.nil?
  end
end
