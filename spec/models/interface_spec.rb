require 'spec_helper'

describe Interface do
  let!(:interface) { Factory :interface}
  it { should validate_presence_of :key }
  it { should validate_uniqueness_of :key }
end
