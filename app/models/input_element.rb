# == Schema Information
#
# Table name: input_elements
#
#  id                :integer          not null, primary key
#  key               :string(255)
#  share_group       :string(255)
#  step_value        :float
#  created_at        :datetime
#  updated_at        :datetime
#  unit              :string(255)
#  fixed             :boolean
#  comments          :text
#  interface_group   :string(255)
#  command_type      :string(255)
#  related_converter :string(255)
#  slide_id          :integer
#  position          :integer
#

class InputElement < ActiveRecord::Base
  include AreaDependent

  has_one :description, as: :describable, dependent: :destroy
  has_one :area_dependency, as: :dependable, dependent: :destroy
  belongs_to :slide

  validates :key, presence: true, uniqueness: true
  validates :position, numericality: true

  scope :households_heating_sliders, -> { where(share_group: 'heating_households') }
  scope :ordered, -> { order('position') }

  accepts_nested_attributes_for :description, :area_dependency


  def title_for_description
    "input_elements.#{key}"
  end

  def translated_name
    ie8_sanitize I18n.t(title_for_description)
  end

  def belongs_to_a_group?
    !interface_group.blank?
  end

  def disabled
    fixed
  end

  # Used by the interface to setup quinn
  def json_attributes
    Jbuilder.encode do |json|
      json.(self, :id, :unit, :share_group, :key, :related_converter, :step_value,
            :disabled, :translated_name, :sanitized_description,
            :fixed, :has_flash_movie)
    end
  end

  ##
  # For showing the name and the action of the inputelement in the admin
  #

  def parsed_name_for_admin
    "#{key} | #{unit}"
  end

  def has_flash_movie
    description.try :embeds_player?
  end

  # For loading multiple flowplayers classname is needed instead of id
  # added the andand check and html_safe to clean up the helper
  #
  def sanitized_description
    ie8_sanitize(
      description.try(:sanitize_embedded_player)
    ).html_safe
  end

  # Used by admin page
  def url
    slide.try :url
  end

  # Silly IE8 doesn't understand &apos; entity which is added in views
  def ie8_sanitize(s)
    return '' if s.blank?
    s.gsub("'", '&#39;').html_safe
  end
end
