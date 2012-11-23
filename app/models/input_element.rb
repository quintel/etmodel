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
  has_paper_trail

  has_one :description, :as => :describable, :dependent => :destroy
  has_one :area_dependency, :as => :dependable, :dependent => :destroy
  has_many :predictions
  belongs_to :slide


  validates :key, :presence => true, :uniqueness => true

  scope :households_heating_sliders, where(:share_group => 'heating_households')
  scope :ordered, order('position')
  accepts_nested_attributes_for :description, :area_dependency


  def title_for_description
    "input_elements.#{key}"
  end

  def translated_name
    ie8_sanitize I18n.t(title_for_description)
  end

  searchable do
    string :key
    text :name_en, :boost => 5 do
      I18n.t("input_elements.#{key}", :locale => :en)
    end
    text :name_nl, :boost => 5 do
      I18n.t("input_elements.#{key}", :locale => :nl)
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

  def belongs_to_a_group?
    !interface_group.blank?
  end

  def disabled
    fixed
  end

  def available_predictions(area = nil)
    predictions.for_area(area || Current.setting.area_code)
  end

  def has_predictions?
    return false unless Current.backcasting_enabled
    available_predictions(Current.setting.area_code).any?
  end
  alias_method :has_predictions, :has_predictions?

  # Used by the interface to setup quinn
  def json_attributes
    Jbuilder.encode do |json|
      json.(self, :id, :unit, :share_group, :key, :related_converter, :step_value,
            :disabled, :translated_name, :parsed_description,:has_predictions,
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
    description.andand.content.andand.include?("player")  || description.andand.content.andand.include?("object")
  end

  ##
  # For loading multiple flowplayers classname is needed instead of id
  # added the andand check and html_safe to clean up the helper
  #
  def parsed_description
    ie8_sanitize(description.andand.content.andand.gsub('id="player"','class="player"') || "").html_safe
  end

  # Use by admin and search page
  def url
    slide.try :url
  end

  # Silly IE8 doesn't understand &apos; entity which is added in views
  def ie8_sanitize(s)
    s.gsub("'", '&#39;')
  end
end
