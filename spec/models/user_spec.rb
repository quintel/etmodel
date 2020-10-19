require 'rails_helper'

describe User do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to belong_to(:teacher).optional }
  it { is_expected.to have_many :students }
end
