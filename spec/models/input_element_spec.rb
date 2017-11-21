require 'rails_helper'

describe InputElement do
  it { is_expected.not_to allow_value('invalid').for(:position) }
  it { is_expected.not_to allow_value(nil).for(:position) }
  it { is_expected.not_to allow_value('').for(:position) }
  it { is_expected.to allow_value(0).for(:position) }
  it { is_expected.to allow_value(1).for(:position) }
end
