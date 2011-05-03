 # More defined in pkg/optimize/input_element.rb!!!
#
#
#
#
class InputElement < ActiveRecord::Base
  include AreaDependent
  has_paper_trail
  strip_attributes! :only => [:start_value_gql, :min_value_gql, :max_value_gql, :start_value, :min_value, :max_value]
  belongs_to :slide
  has_one :description, :as => :describable
  has_one :area_dependency, :as => :dependable
  has_many :expert_predictions

  scope :ordered_for_admin, order("slides.controller_name, slides.action_name, slides.name, input_elements.id").includes('slide')
  scope :max_complexity, lambda {|complexity| where("complexity <= #{complexity}") }
  
  scope :with_share_group, where('NOT(share_group IS NULL OR share_group = "")')

  scope :contains, lambda{|search| 
    where([
      "start_value_gql LIKE :q OR min_value_gql LIKE :q OR max_value_gql LIKE :q OR `keys` LIKE :q OR `attr_name` LIKE :q",
      {:q => "%#{search}%"}
    ])
  }


  def self.input_elements_grouped
    @input_elements_grouped ||= InputElement.
      with_share_group.select('id, share_group, `key`').
      group_by(&:share_group)
  end

  def step_value
    # cache(:step_value) do
      if Current.scenario.municipality? and self.locked_for_municipalities? and self.slide.andand.controller_name == "supply" 
        (self[:step_value] / 1000).to_f
      else
        self[:step_value].to_f
      end
      
    # end
  end

  def title_for_description
    "slider.#{name}"
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

  
  def global_cache_settings
    {}
  end
  
  
  def cache_conditions_key
    "%s_%s_%s_%s" % [self.class.name, self.id, Current.graph.id, Current.scenario.area.id]
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

  ##
  # update hash for this input_element with the given value.
  # {'converters' => {'converter_keys' => {'demand_growth' => 2.4}}}
  #
  # @param [Float] value the (user) value of that input_element
  # @return [Hash]
  #
  def update_statement(value)
    {
      update_type => {
        keys => {
          attr_name => value / factor
    }}}
  end

  def remainder?
    input_element_type == 'remainder'
  end

  # The input elements that must also be updated if this input element is updated.
  def input_elements_to_update
    return [] if self.update_value.blank?
    elements_to_update = self.update_value.blank? ? [] : self.update_value.split("_")
    InputElement.find(elements_to_update)
  end

  # some input values are not adaptable by municipalities
  def semi_unadaptable?
    Current.scenario.municipality? && locked_for_municipalities == true
  end
  alias_method :semi_unadaptable, :semi_unadaptable?


  def hidden_input_element?
    false
  end

  def min_value
    self[:min_value] || 0
  end

  def max_value
    self[:max_value] || 0
  end


  def self.households_heating_sliders
    where("slide_id = 4")
  end
  
  
  
  #def fixed?
  #  
  #end
  def disabled
    has_locked_input_element_type?(input_element_type) || blacklisted_if_whitelist_available?(id)
  end
  #############################################
  # Methods that interact with a users values
  #############################################

  ##
  # The current value of this slider for the current user. If the user hasn't touched
  # the slider, its start value is return.
  #
  # @return [Float] Users value
  #
  def user_value
    unless input_element_type == "fixed" # if a slider is fixed, the user cant 
      value = Current.scenario.user_value_for(self) 
    end
    Current.scenario.store_user_value(self, value || start_value || 0).round(2)
  end
  
  def backbone_options
    [
      :id, :name, :unit, :share_group,
      :start_value, :min_value, :max_value, :step_value, 
      :user_value, :disabled, :translated_name, 
      :semi_unadaptable,:disabled_with_message, 
      :input_element_type, :has_flash_movie
    ].inject({}) do |hsh, key|
      hsh.merge key.to_s => self.send(key)
    end
  end

  def as_json(options = {})
    super(:only => [:id, :name, :unit, :share_group, :factor], 
      :methods => [ 
        :start_value, 
        :start_value_gql,
        :min_value, 
        :min_value_gql,
        :max_value, 
        :max_value_gql,
        :step_value, 
        :number_to_round_with,
        :output, :user_value, :disabled, :translated_name, 
        :semi_unadaptable,:disabled_with_message, 
        :input_element_type, :has_flash_movie])
  end

  def translated_name
    I18n.t("slider.%s" % self.name)
  end

  ##
  # For loading multiple flowplayers classname is needed instead of id
  # added the andand chack and html_safe to clean up the helper
  #
  def parsed_description
    (description.andand.content.andand.gsub('id="player"','class="player"') || "").html_safe
  end
  
  def parsed_label
    "#{Current.gql.query_present(label_query).round(2)} #{label}".html_safe unless label_query.blank?
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
    val = Current.scenario.user_values.delete(self.id)
    if updates = Current.scenario.update_statements[update_type]
      if keys = updates[keys]
        val = keys.delete(attr_name)
      end
    end
  end


  ##### optimizer

  def calculated_step_value
    ((max_value - min_value) / 100).round(2)
  end


  # TODO refactor (seb 2010-10-11)
  def use_for_optimize?
    self.share_group != "other hidden_slider" and 
    self.update_type != "carriers" and 
    self.update_type != "policies" and 
    self.slide.andand.controller_name !="costs" and 
    self.slide.andand.controller_name !=nil and 
    self.input_element_type != "fixed" and 
    self.share_group != "hidden_slider"
  end
  alias_method :use_for_optimize, :use_for_optimize?

  def use_for_calibrate
    self.use_for_optimize and self.keys != nil and self.keys != 0 and self.keys != "" and !self.attr_name.include? "_conversion"
  end

  def use_value
    if value = Current.user_values[self.id] rescue nil
    elsif value = self.start_value rescue nil
    elsif value = Current.gql.query(self.start_value_gql) rescue nil
    end
    return value
  end  

  def update_current(value)
    # DON'T do that for now. because of DoubleGqlLoad Weirdness
    # value = value_within_range(value.to_f)
    # value = value.to_f
    # Current.user_values[id] = value
    # Current.update_user_updates({update_type => {
    #   keys => {attr_name => value / factor}
    # }})
    Current.scenario.update_input_element(self, value)
  end

  def value_within_range(value)
    raise "DANGEROUS: DoubleGqlLoad Weirdness ahead"
    if value > max_value
      max_value
    elsif value < min_value
      min_value
    else
      value
    end
  end

  ##
  # @tested 2010-12-22 robbert
  #
  def has_locked_input_element_type?(input_type)
    %w[fixed remainder fixed_share].include?(input_type)
  end

  ##
  # @tested 2010-12-22 robbert
  #
  def blacklisted_if_whitelist_available?(id)
    return false if Current.server_config.whitelist.nil?
    return !Current.server_config.whitelist.include?(id.to_i)
  end
  
  def has_flash_movie
    description.andand.content.andand.include?("player")  || description.andand.content.andand.include?("object")
  end
  
  def disabled_with_message?
    disabled && Current.scenario.transitionprice?
  end
  alias_method :disabled_with_message, :disabled_with_message?

  def is_policy?
    key.split('_').first == "policy" 
  end
end





# == Schema Information
#
# Table name: input_elements
#
#  id                        :integer(4)      not null, primary key
#  name                      :string(255)
#  slide_id                  :integer(4)
#  share_group               :string(255)
#  start_value_gql           :string(255)
#  min_value_gql             :string(255)
#  max_value_gql             :string(255)
#  min_value                 :float
#  max_value                 :float
#  start_value               :float
#  keys                      :text
#  attr_name                 :string(255)
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
#  update_value              :string(255)
#  complexity                :integer(4)      default(1)
#  interface_group           :string(255)
#  update_max                :string(255)
#  locked_for_municipalities :boolean(1)
#  label_query               :string(255)
#  key                       :string(255)
#

