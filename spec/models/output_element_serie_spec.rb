require 'spec_helper'

describe OutputElementSerie, type: :model do
  it { should validate_presence_of :gquery }
end
