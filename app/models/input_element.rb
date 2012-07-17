# == Schema Information
#
# Table name: input_elements
#
#  id                :integer(4)      not null, primary key
#  key               :string(255)
#  share_group       :string(255)
#  step_value        :float
#  created_at        :datetime
#  updated_at        :datetime
#  unit              :string(255)
#  fixed             :boolean(1)
#  comments          :text
#  interface_group   :string(255)
#  input_id          :integer(4)
#  command_type      :string(255)
#  related_converter :string(255)
#

class InputElement < ActiveRecord::Base
  include AreaDependent
  has_paper_trail

  has_one :description, :as => :describable, :dependent => :destroy
  has_one :area_dependency, :as => :dependable, :dependent => :destroy
  has_many :predictions
  has_many :slider_positions, :foreign_key => :slider_id
  has_many :slides, :through => :slider_positions


  validates :key, :presence => true, :uniqueness => true
  validates :input_id, :presence => true

  scope :households_heating_sliders, where(:share_group => 'heating_households')
  scope :ordered, order('position')
  accepts_nested_attributes_for :description, :area_dependency


  def title_for_description
    "input_elements.#{key}"
  end

  def translated_name
    I18n.t(title_for_description)
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

  def cache_conditions_key
    [self.class.name, self.id, Current.setting.area.id].join('_')
  end

  # Cache
  def cache(method, options = {}, &block)
    if options[:cache] == false
      yield
    else
      Rails.cache.fetch("%s-%s" % [cache_conditions_key, method.to_s]) do
        yield
      end
    end
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

  #############################################
  # Methods that interact with a users values
  #############################################

  def as_json(options = {})
    super(:only => [:id, :input_id, :unit, :share_group, :factor, :key, :related_converter],
          :methods => [
            :step_value,
            :output, :user_value, :disabled, :translated_name,
            :parsed_description,:has_predictions,
            :fixed, :has_flash_movie])
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
    (description.andand.content.andand.gsub('id="player"','class="player"') || "").html_safe
  end

  # Use by admin and search page
  def url
    slides.first.try :url
  end
end
