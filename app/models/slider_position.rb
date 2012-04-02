# has_many :through intermediate object
#
class SliderPosition < ActiveRecord::Base
  belongs_to :slide
  belongs_to :slider, :class_name => "InputElement"
  validates :slide, :presence => true
  validates :slider, :presence => true
  scope :ordered, order('position')

  attr_accessible :slide_id, :slider_id, :position
end
