# == Schema Information
#
# Table name: input_elements
#
#  id                        :integer(4)      not null, primary key
#  name                      :string(255)
#  key                       :string(255)
#  slide_id                  :integer(4)
#  share_group               :string(255)
#  order_by                  :float
#  step_value                :decimal(4, 2)
#  created_at                :datetime
#  updated_at                :datetime
#  update_type               :string(255)
#  unit                      :string(255)
#  factor                    :float
#  input_element_type        :string(255)
#  label                     :string(255)
#  comments                  :text
#  complexity                :integer(4)      default(1)
#  interface_group           :string(255)
#  locked_for_municipalities :boolean(1)
#  input_id                  :integer(4)
#  growth                    :boolean(1)
#

class InputElement < ActiveRecord::Base
  CONVERSIONS = YAML.load(Rails.root.join('db', 'unit_conversions.yml'))

  include AreaDependent
  has_paper_trail

  belongs_to :slide
  has_one :description, :as => :describable
  has_one :area_dependency, :as => :dependable
  has_many :expert_predictions
  has_many :predictions

  validates :key, :presence => true, :uniqueness => true
  validates :input_id, :presence => true

  scope :ordered_for_admin, order("slides.controller_name, slides.action_name, slides.name, input_elements.id").includes('slide')
  scope :max_complexity, lambda {|complexity| where("complexity <= #{complexity}") }
  scope :with_share_group, where('NOT(share_group IS NULL OR share_group = "")')
  scope :households_heating_sliders, where(:slide_id => 4)

  accepts_nested_attributes_for :description

  def self.input_elements_grouped
    @input_elements_grouped ||= InputElement.
      with_share_group.select('id, share_group, `key`').
      group_by(&:share_group)
  end

  def step_value
    if Current.setting.municipality? and self.locked_for_municipalities? and self.slide.andand.controller_name == "supply"
      (self[:step_value] / 1000).to_f
    else
      self[:step_value].to_f
    end
  end

  def title_for_description
    "slider.#{name}"
  end

  def translated_name
    I18n.t(title_for_description)
  end

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

  def number_to_round_with
    if factor == 1
      step_value == 1 ? 0 : 1
    elsif factor >= 100
      3
    end
  end

  # TODO refactor (seb 2010-10-11)
  def start_value
    return self[:start_value]
  end

  def remainder?
    input_element_type == 'remainder'
  end

  # some input values are not adaptable by municipalities
  def semi_unadaptable?
    Current.setting.municipality? && locked_for_municipalities == true
  end
  alias_method :semi_unadaptable, :semi_unadaptable?

  def min_value
    self[:min_value] || 0
  end

  def max_value
    self[:max_value] || 0
  end


  def disabled
    has_locked_input_element_type?(input_element_type)
  end

  # Retrieves an array of suitable unit conversions for the element. Allows
  # the user to swap between different unit types in the UI.
  #
  # @return [Array(Hash)]
  #
  def conversions
    CONVERSIONS[key] || Array.new
  end

  def available_predictions
    predictions.for_area(Current.setting.region)
  rescue
    []
  end

  def has_predictions?
    return false unless Current.backcasting_enabled
    available_predictions.any?
  end
  alias_method :has_predictions, :has_predictions?

  #############################################
  # Methods that interact with a users values
  #############################################

  def as_json(options = {})
    super(:only => [:id, :input_id, :name, :unit, :share_group, :factor],
          :methods => [
            :step_value,
            :number_to_round_with,
            :output, :user_value, :disabled, :translated_name,
            :semi_unadaptable,:disabled_with_message, :has_predictions,
    :input_element_type, :has_flash_movie, :conversions])
  end

  ##
  # For loading multiple flowplayers classname is needed instead of id
  # added the andand chack and html_safe to clean up the helper
  #
  def parsed_description
    (description.andand.content.andand.gsub('id="player"','class="player"') || "").html_safe
  end

  ##
  # For showing the name and the action of the inputelement in the admin
  #

  def parsed_name_for_admin
    "#{key} | #{name} | #{unit} | #{input_element_type}"
  end

  ##
  # Resets the user values
  #
  # @todo Probably this should be moved into a Scenario class
  #
  def reset
  end


  ##### optimizer

  ##
  # @tested 2010-12-22 robbert
  #
  def has_locked_input_element_type?(input_type)
    %w[fixed remainder fixed_share].include?(input_type)
  end

  def has_flash_movie
    description.andand.content.andand.include?("player")  || description.andand.content.andand.include?("object")
  end

end
