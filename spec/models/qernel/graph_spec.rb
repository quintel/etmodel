require 'spec_helper'

module Qernel
#  describe Graph do
#    describe "only converters" do
#
#      before do
#        @dataset = Qernel::Dataset.new(1)
#        @c1 = Converter.new(1, 'El Dem. HH')
#        @c1.key = :electricity_demand
#        @c1.sector_id = 1
#        @c1.stub!(:full_key).and_return(:electricity_demand_households)
#        @c1.dataset = @dataset
#        @c2 = Converter.new(2, 'El Dem. Ind')
#        @c2.key = :electricity_demand
#        @c2.sector_id = 2
#        @c2.stub!(:groups).and_return([Group.new(1, :primary_demand)])
#        @c2.dataset = @dataset
#        @c3 = Converter.new(3, 'Heating Demand HH')
#        @c3.key = :heating_demand
#        @c3.sector_id = 1
#        @c3.stub!(:groups).and_return([Group.new(1, :primary_demand)])
#        @c3.dataset = @dataset
#        @graph = Graph.new([@c1, @c2, @c3], @dataset)
#      end
#
#      it "should return empty array if nothing found" do
#        @graph.group_converters(:xyz).should eql([])
#        @graph.sector_converters(:xyz).should eql([])
#      end
#
#      describe "#sector_converters" do
#        it "should return converters 1,3 for sector: :households or 'households'" do
#          @graph.sector_converters(:households).should have(2).items
#          @graph.sector_converters(:households).should include(@c1)
#          @graph.sector_converters(:households).should include(@c3)
#          @graph.sector_converters('households').should include(@c3)
#        end
#      end
#
#      describe "#group_converters('primary_demand')" do
#        it "should return converters 2,3 for group: :primary_demand or 'primary_demand'" do
#          @graph.group_converters(:primary_demand).should have(2).items
#          @graph.group_converters(:primary_demand).should include(@c2)
#          @graph.group_converters(:primary_demand).should include(@c3)
#          @graph.group_converters('primary_demand').should include(@c3)
#        end
#      end
#
#      describe "#converter()" do
#        it "should find by (excel_)id" do
#          @graph.converter(1).should be(@c1)
#        end
#
#        it "should find by key as symbol" do
#          @graph.converter(:electricity_demand_households).should be(@c1)
#        end
#
#        it "should find by key as string" do
#          @graph.converter('electricity_demand_households').should be(@c1)
#        end
#      end
#    end
#  end
end
