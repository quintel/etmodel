require 'rails_helper'

describe Slide do
  it { is_expected.to validate_presence_of :key }
end

