# frozen_string_literal: true

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
#  position          :integer
#

# Model representing a slider in the front-end. Settings get stored in scenarios
class InputElement < YModel::Base
  include AreaDependent::YModel
  source_file 'config/interface/input_elements'

  ENUM_UNITS = %w[radio weather-curves].freeze

  belongs_to :slide, foreign_key: :sidebar_item_key

  class << self
    def households_heating_sliders
      where(share_group: 'heating_households')
    end

    def ordered
      all.sort_by(&:position)
    end

    def with_related_converter_like(converter_name)
      all.reject { |ie| ie.related_converter.nil? }
        .select { |ie| ie.related_converter.include?(converter_name || '') }
    end
  end

  def title_for_description
    "input_elements.#{key}"
  end

  def translated_name
    ie8_sanitize I18n.t(title_for_description)
  end

  def description
    I18n.t("descriptions_input_elements.#{key}.content")
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
      json.call(
        self, :id, :unit, :share_group, :key, :related_converter,
        :converter_source_url, :step_value, :draw_to_min, :draw_to_max,
        :disabled, :translated_name, :sanitized_description, :fixed,
        :has_flash_movie
      )
    end
  end

  def converter_source_url
    return Converter.find related_converter if related_converter.present?

    nil
  end

  ##
  # For showing the name and the action of the inputelement in the admin
  #

  def parsed_name_for_admin
    "#{key} | #{unit}"
  end

  def has_flash_movie # rubocop:disable Naming/PredicateName
    description&.include?('player') ||
      description&.include?('object')
  end

  # For loading multiple flowplayers classname is needed instead of id
  # added the andand check and html_safe to clean up the helper
  #
  def sanitized_description
    ie8_sanitize(description).html_safe
  end

  # Used by admin page
  def url
    slide.try :url
  end

  # Allows the input to be used as an argument to play_url to link directly to
  # the correct page.
  #
  # For example:
  #
  #   play_url(*input.url_components)
  def url_components
    slide ? slide.url_components : []
  end

  # Silly IE8 doesn't understand &apos; entity which is added in views
  def ie8_sanitize(string)
    return '' if string.blank?

    string.gsub("'", '&#39;').html_safe
  end

  def enum?
    ENUM_UNITS.include?(unit)
  end
end
