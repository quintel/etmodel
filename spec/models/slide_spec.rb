require 'rails_helper'
require 'support/model_with_a_position_attribute'

describe Slide do
  it { is_expected.to validate_presence_of :key }
  it_behaves_like 'a model with a position attribute'
end

