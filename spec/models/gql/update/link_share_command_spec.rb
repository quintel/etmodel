require 'spec_helper'

module Gql::Update
  describe LinkShareCommand do
    describe "#responsible?" do
      %w[
        carrier_input_link_share_growth_rate
        carrier_input_link_share
        carrier_output_link_share
      ].each do |key|
        specify { LinkShareCommand.responsible?(key).should be_true }
      end
    end
  end
end
