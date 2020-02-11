require 'rails_helper'

describe Tab do
  describe '.' do
    subject { Tab }
    it { is_expected.to respond_to :all }
    it { is_expected.to respond_to :where }
    it { is_expected.to respond_to :find }
    it { is_expected.to respond_to :find_by_key }
    it { is_expected.to respond_to :ordered }
    it { is_expected.to respond_to :frontend }
  end

  subject { Tab.new }
  it { is_expected.to respond_to :allowed_sidebar_items }
  it { is_expected.to respond_to :sidebar_items }
  it { is_expected.to respond_to :area_dependency }
  it { is_expected.to be_a AreaDependent::ActiveRecord }
end
