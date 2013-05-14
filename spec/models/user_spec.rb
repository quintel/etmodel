require 'spec_helper'

describe User do
  it { should validate_presence_of :name }
  it { should belong_to :teacher }
  it { should have_many :students }
end
