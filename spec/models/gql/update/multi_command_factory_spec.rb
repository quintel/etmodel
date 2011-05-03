require 'spec_helper'

module Gql::Update
  describe MultiCommandFactory do
    describe "#responsible?" do
      %w[
        rc_value
        om_growth_total
        number_of_plants
        ventilation_rate_buildings
      ].each do |key|
        specify { MultiCommandFactory.responsible?(key).should be_true }
      end
    end


    describe "basic factory" do
      before do
        @value = 0.3
        @lookup_value = 20
        @min_value = 0.2
        @graph = mock_model(::Qernel::Graph)
        @converter = mock_model(::Qernel::Converter)
        @factory = MultiCommandFactory.new(@graph,@converter, nil, @value)
      end

      describe "number_of_plants" do
        #pending
      end

      describe "#rc_value" do
        before do
          @factory.stub!(:key).and_return('rc_value')
          @converter.stub!(:converter).and_return(@converter)
        end

        describe "#saving_percentage_for_rc_value" do
          before { 
            @factory.stub!(:value).and_return(@value)
            @lookup_value = 20
            @min_value = 0.2
          }
          specify { @factory.send(:saving_percentage_for_rc_value, @lookup_value, @min_value).should be_within( 0.001 ).of( (1 - ((1 - @min_value) * @lookup_value / @value + @min_value))) }
        end

        context "extra_insulation_savings_households_energetic" do
          before do
            @graph.stub_chain(:area, :insulation_level_existing_houses).and_return(@lookup_value)
            @converter.stub!(:to_s).and_return("extra_insulation_savings_households_energetic")
          end
          subject { @factory.cmds.first }
          it { should_not be_nil}
          its(:object) { should == @converter }
        end

        context "heating_savings_insulation_new_households_energetic" do
          before do
            @graph.stub_chain(:area, :insulation_level_new_houses).and_return(@lookup_value)
            @converter.stub!(:to_s).and_return("heating_savings_insulation_new_households_energetic")
          end
          subject { @factory.cmds.first }
          it { should_not be_nil}
          specify {@factory.cmds.first.instance_variable_get('@attr_name').should == "useable_heat_output_link_share"}
          its(:object) { should == @converter }
        end

        context "heating_schools_current_insulation_buildings_energetic" do
          before do
            @graph.stub_chain(:area, :insulation_level_schools).and_return(@lookup_value)
            @converter.stub!(:to_s).and_return("heating_schools_current_insulation_buildings_energetic")
          end
          subject { @factory.cmds.first }
          it { should_not be_nil}
          specify {@factory.cmds.first.instance_variable_get('@attr_name').should == "useable_heat_input_link_share"}
          its(:object) { should == @converter }
        end

        context "heating_offices_current_insulation_buildings_energetic" do
          before do
            @graph.stub_chain(:area, :insulation_level_offices).and_return(@lookup_value)
            @converter.stub!(:to_s).and_return("heating_offices_current_insulation_buildings_energetic")
          end
          subject { @factory.cmds.first }
          it { should_not be_nil}
          specify {@factory.cmds.first.instance_variable_get('@attr_name').should == "useable_heat_input_link_share"}
          its(:object) { should == @converter }
        end
      end

      describe "#om_growth_total" do
        before do
          @factory.stub!(:key).and_return('om_growth_total')
        end
        subject { @factory.cmds}
        it { should have(2).items}
      end

      describe "#ventilation_rate_buildings" do
        before do
          @factory.stub!(:key).and_return('ventilation_rate_buildings')
          @graph.stub_chain(:query, :area, :ventilation_rate).and_return(5.0)
          @converter.stub!(:demand).and_return(30.0)
        end
        subject { @factory.execute.first }
        it { should_not be_nil }
        specify { @factory.execute.first.instance_variable_get('@attr_name').should == :preset_demand }
        its(:object) { should == @converter }
        its(:value) { should be_within( 0.01).of(@factory.value / 5.0 * 30.0) }
      end
    end
  end
end
