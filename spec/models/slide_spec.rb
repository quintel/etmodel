require 'spec_helper'

describe Slide, type: :model do
  it { should validate_presence_of :key }
end

