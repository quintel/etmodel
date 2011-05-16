require 'spec_helper'

describe User do
  it { should validate_presence_of :name }
end
