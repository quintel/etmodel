require 'rails_helper'
require 'support/model_with_a_position_attribute'

describe Tab do
# We are testing YModel in this file as well.

  describe '.' do
    subject { Tab }
    it { is_expected.to respond_to :all }
    it { is_expected.to respond_to :where }
    it { is_expected.to respond_to :find }
    it { is_expected.to respond_to :find_by_key }
    it { is_expected.to respond_to :ordered }
    it { is_expected.to respond_to :frontend }
  end

  subject { Tab.new  }
  it { is_expected.to respond_to :allowed_sidebar_items}
  it { is_expected.to respond_to :sidebar_items }
  it { is_expected.to respond_to :area_dependency }
  it { is_expected.to be_a AreaDependent }
end

#
# # == Schema Information
# #
# # Table name: tabs
# #
# #  id          :integer          not null, primary key
# #  key         :string(255)
# #  nl_vimeo_id :string(255)
# #  en_vimeo_id :string(255)
# #  position    :integer
# #
#
# class Tab < ActiveRecord::Base
#   include AreaDependent
#
#   validates :key, presence: true, uniqueness: true
#   validates :position, numericality: true
#
#   has_many :sidebar_items, dependent: :nullify
#   has_one :area_dependency, as: :dependable, dependent: :destroy
#
#   accepts_nested_attributes_for :area_dependency
#
#   scope :ordered, -> { order('position') }
#
#   # Returns all Tabs intended for display to ordinary users.
#   def self.frontend
#     ordered.reject(&:area_dependent)
#   end
#
#   def allowed_sidebar_items
#     sidebar_items.roots.includes(:area_dependency).ordered.reject(&:area_dependent)
#   end
# end

### Data
#
# ---
# - id: 1
#   key: overview
#   nl_vimeo_id: ''
#   en_vimeo_id: ''
#   position: 1
# - id: 2
#   key: demand
#   nl_vimeo_id: '19658877'
#   en_vimeo_id: '20191812'
#   position: 2
# - id: 3
#   key: supply
#   nl_vimeo_id: '19658916'
#   en_vimeo_id: '20191972'
#   position: 3
# - id: 4
#   key: costs
#   nl_vimeo_id: '19658896'
#   en_vimeo_id: '20191894'
#   position: 5
# - id: 5
#   key: flexibility
#   nl_vimeo_id: ''
#   en_vimeo_id: ''
#   position: 4
# - id: 6
#   key: data
#   nl_vimeo_id:
#   en_vimeo_id:
#   position: 6
# - id: 7
#   key: targets
#   nl_vimeo_id: ''
#   en_vimeo_id: ''
#   position: 0
#
