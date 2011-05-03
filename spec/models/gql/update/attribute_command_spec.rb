require 'spec_helper'

module Gql::Update
  describe AttributeCommand do
    describe "#responsible?" do
      %w[demand_decrease_total].each do |key|
        specify { AttributeCommand.responsible?(key).should be_true }
      end
    end
  end
end
