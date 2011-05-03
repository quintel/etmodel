require 'spec_helper'

module Gql

describe Gql do

  describe "#select" do
    before do
      @klass = Selecting::SelectStringParser
    end

    context "1_AND_2" do
      before { @result = @klass.new('1_AND_2') }

      specify { @result.converter_keys.should have(2).items }
      specify { @result.converter_keys.should include(1) }
      specify { @result.converter_keys.should include(2) }
    end

    context "group_primary_demand" do
      before { @result = @klass.new('group_primary_demand') }

      specify {@result.group_keys.should have(1).items }
      specify {@result.group_keys.should include('primary_demand') }
    end

    context "sector_households" do
      before { @result = @klass.new('sector_households') }

      specify { @result.converter_keys.should have(0).items }
      specify { @result.sector_keys.should have(1).items }
      specify { @result.sector_keys.should include('households') }
    end

    context "sector_households_AND_sector_industry" do
      before { @result = @klass.new('sector_households_AND_sector_industry') }

      specify { @result.sector_keys.should include('households') }
      specify { @result.sector_keys.should include('industry') }
      specify { @result.sector_keys.should have(2).items }
      specify { @result.converter_keys.should have(0).items }
    end

    context "sector_households_AND_some_converter_key" do
      before { @result = @klass.new('sector_households_AND_some_converter_key') }

      specify { @result.sector_keys.should include('households') }
      specify { @result.sector_keys.should have(1).items }
      specify { @result.converter_keys.should have(1).items }
    end

    context "sector_" do
      before { @result = @klass.new('sector_') }

      specify { @result.sector_keys.should have(1).items }
    end
  end
end

end
