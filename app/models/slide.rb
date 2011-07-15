# == Schema Information
#
# Table name: slides
#
#  id                        :integer(4)      not null, primary key
#  controller_name           :string(255)
#  action_name               :string(255)
#  name                      :string(255)
#  order_by                  :integer(4)
#  image                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  sub_header                :string(255)
#  complexity                :integer(4)      default(1)
#  sub_header2               :string(255)
#  subheader_image           :string(255)
#  key                       :string(255)
#

class Slide < ActiveRecord::Base
  has_paper_trail

  has_one :description, :as => :describable
  has_many :input_elements, :order => "order_by"

  validates :key, :presence => true, :uniqueness => true

  scope :controller, lambda {|controller| where(:controller_name => controller) }
  scope :action, lambda {|action| where(:action_name => action) }
  scope :max_complexity, lambda {|complexity| where("complexity <= #{complexity}") }

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

  def show_house_selection_tool
    # DEBT: Create show_house_selection_tool flag in table
    true if [1,4,5,106,108].include?(id)
  end

  def show_expert_prediction_link
    input_elements.any?{|ie| ie.expert_predictions.present? }
  end

  def infrastructure_slide?
    id == (103 || 104)
  end


  def visible_input_elements
    Rails.logger.warn('DEPRECATED: visible_sectors')
    if infrastructure_slide?
      #EXEPTION: simulate a slider for this slides, otherwise they will be hidden because they dont have sliders
      ["1"]
    else
      input_elements.max_complexity(Current.setting.complexity).reject {|x| x.hidden_input_element?}
    end
  end

  def self.visible_sectors(slides)
    Rails.logger.warn('DEPRECATED: visible_sectors')
    slides.reject { |cat, slides|  slides.map { |slide|  slide.visible_input_elements }.flatten.empty?  } 
  end

  def input_elements_for_display
    Rails.logger.warn('DEPRECATED: input_elements_for_display')
    self.input_elements.max_complexity(Current.setting.complexity).reject(&:area_dependent)
  end
  
  ##
  # Gets the input elements without a interface group for a slide
  #
  def input_elements_without_interface_group
    Rails.logger.warn('DEPRECATED: input_elements_without_interface_group')
    input_elements_for_display.select{|input_element| input_element.interface_group.blank? }
  end

  ##
  # Gets a interface groups hash with an array of input elements.
  #
  # @return [Hash] interface_group => [InputElement]
  #
  def interface_groups_with_input_elements
    Rails.logger.warn('DEPRECATED: interface_groups_with_input_elements')
    interface_groups = {}
    input_elements = input_elements_for_display.reject{|input_element| input_element.interface_group.blank? }

    input_elements.each do |input_element|
      interface_groups[input_element.interface_group] ||= [] 
      interface_groups[input_element.interface_group] << input_element
    end

    interface_groups
  end
  
  def contains_chp_slider?
    [44, 57, 101, 102].include?(id)    
  end
  
  def parsed_name_for_admin
    "#{action_name.andand[0..30]} | #{name}"
  end
  
  def image_path
    "/images/layout/#{image}" if image.present? 
  end

  def title_for_description
    "slidetitle.#{name}"
  end

end
