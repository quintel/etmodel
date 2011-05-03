require 'spec_helper'

module Gql

  describe StoredProcedure do
#
#    before :all do
#      Current.gql = @gql = load_gql_fixture
#      load_fixtures
#    end
#
#    before :each do
#      # Current.stub!(:gql).and_return(@gql)
#      @policy = @gql.policy
#      @sp = StoredProcedure.new
#    end
#
#    describe "policy_targets_met" do
#      before do
#        @expected = GqueryResult.create [[2010, 0],[2040, 0]]
#      end
#      subject { @sp.policy_targets_met }
#      its(:present_value) { should be_near(@expected.present_value) }
#      its(:future_value) { should be_near(@expected.future_value) }
#    end
#
#    describe "present_area" do
#      before do
#        @expected = Qernel::Area.new('nl',
#                                     :area => "nl",
#                                     :co2_price => 0.01551,
#                                     :co2_percentage_free => 0.85,
#                                     :el_import_capacity => nil,
#                                     :el_export_capacity => 16200000.0,
#                                     :co2_emission_1990 => 151.2,
#                                     :co2_emission_2009 => 165.1,
#                                     :co2_emission_electricity_1990 => 39.92,
#                                     :roof_surface_available_pv => 266.667,
#                                     :areable_land => 11099.0,
#                                     :offshore_suitable_for_wind => 1700.0,
#                                     :onshore_suitable_for_wind => 11099.0,
#                                     :coast_line => 451.0,
#                                     :available_land => 11099.0,
#                                     :land_available_for_solar => 11099.0,
#                                     :km_per_car => 17452.1,
#                                     :import_electricity_primary_demand_factor => 1.82,
#                                     :export_electricity_primary_demand_factor => 1.0,
#                                     :capacity_buffer_in_mj_s => 1600.0,
#                                     :capacity_buffer_decentral_in_mj_s => 20000.0,
#                                     :km_per_truck => 319729.0,
#                                     :number_households => 7242200.0,
#                                     :number_inhabitants => 16485800.0,
#                                     :annual_infrastructure_cost => 6087.63)
#        @attrs_to_check = Qernel::Area::ATTRIBUTES_USED.reject { |a| @expected.send(a).nil? }
#      end
#      subject { @sp.present_area }
#      its(:area) { should == @expected.area }
#      specify "other attributes" do
#        @attrs_to_check.each do |attr|
#          @sp.present_area.send(attr).should be_near @expected.send(attr)
#        end
#      end
#    end
#
#
#   describe "policy_total_energy_cost" do
#     before do
#       policy_goal = @policy.goal(:total_energy_cost)
#       @expected = GqueryResult.create [[2010, 41.8033331088373],[2040, 41.8033331088373]]
#     end
#     subject { @sp.policy_total_energy_cost }
#     its(:present_value) { should be_near @expected.present_value }
#     its(:future_value) { should be_near @expected.future_value }
#   end
#
#   describe "policy_electricity_cost" do
#     before do
#       policy_goal = @policy.goal(:electricity_cost)
#       @expected = GqueryResult.create [[2010, 84.9885011063692],[2040, 84.9885011063692]]
#     end
#     subject { @sp.policy_electricity_cost }
#     its(:present_value) { should be_near @expected.present_value }
#     its(:future_value) { should be_near @expected.future_value }
#   end
#
#   describe "policy_co2_emission" do
#     before do
#       policy_goal = @policy.goal(:co2_emission)
#       @expected = GqueryResult.create [[2010, 161.058616696992],[2040, 151.2]]
#     end
#     subject { @sp.policy_co2_emission }
#     its(:present_value) { should be_near @expected.present_value }
#     its(:future_value) { should be_near @expected.future_value }
#   end
#
#   describe "policy_renewable_percentage" do
#     before do
#       policy_goal = @policy.goal(:renewable_percentage)
#       @expected = GqueryResult.create [[2010, 4.86136111863168],[2040, 4.86136111863168]]
#     end
#     subject { @sp.policy_renewable_percentage }
#     its(:present_value) { should be_near @expected.present_value }
#     its(:future_value) { should be_near @expected.future_value }
#   end
#
#    describe "policy_onshore_land" do
#      before do
#        area = @policy.present_area.onshore_suitable_for_wind
#        policy_goal = @policy.goal(:onshore_land)
#        @expected = GqueryResult.create [[2010, 0.00242395280118989], [2040, 0.00242395280118989]]
#      end
#      subject { @sp.policy_onshore_land }
#      its(:present_value) { should be_near @expected.present_value }
#      its(:future_value) { should be_near @expected.future_value }
#    end
#
#    describe "policy_onshore_coast", :focus => true do
#      before do
#        area = @policy.present_area.coast_line
#        policy_goal = @policy.goal(:onshore_coast)
#        @expected = GqueryResult.create [[2010, 0.12870798548188], [2040, 0.12870798548188]]
#      end
#      subject { @sp.policy_onshore_coast }
#      its(:present_value) { should be_near @expected.present_value }
#      its(:future_value) { should be_near @expected.future_value }
#    end
#
#
#    describe "policy_offshore" do
#      before do
#        area = @policy.present_area.offshore_suitable_for_wind
#        policy_goal = @policy.goal(:offshore)
#        @expected = GqueryResult.create [[2010, 0.0349963606251136], [2040, 0.0349963606251136]]
#      end
#      subject { @sp.policy_offshore }
#      its(:present_value) { should be_near @expected.present_value }
#      its(:future_value) { should be_near @expected.future_value }
#    end
#
#    describe "policy_roofs_for_solar_panels" do
#      before do
#        area = @policy.present_area.roof_surface_available_pv
#        policy_goal = @policy.goal(:roofs_for_solar_panels)
#        @expected = GqueryResult.create [[2010, 0.0641249807627583], [2040, 0.0641249807627583]]
#      end
#      subject { @sp.policy_roofs_for_solar_panels }
#      its(:present_value) { should be_near @expected.present_value }
#      its(:future_value) { should be_near @expected.future_value }
#    end
#
#    describe "policy_land_for_solar_panels" do
#      before do
#        area = @policy.present_area.land_available_for_solar
#        policy_goal = @policy.goal(:land_for_solar_panels)
#        @expected = GqueryResult.create [[2010, 0.0], [2040, 0.0]]
#      end
#      subject { @sp.policy_land_for_solar_panels }
#      its(:present_value) { should be_near @expected.present_value }
#      its(:future_value) { should be_near @expected.future_value }
#    end
#
#    describe "policy_land_for_csp" do
#      before do
#        area = @policy.present_area.land_available_for_solar
#        policy_goal = @policy.goal(:land_for_csp)
#        @expected = GqueryResult.create [[2010, 0.0], [2040, 0.0]]
#      end
#      subject { @sp.policy_land_for_csp }
#      its(:present_value) { should be_near @expected.present_value }
#      its(:future_value) { should be_near @expected.future_value }
#    end
#
#    # these don't exist yet
##    describe "policy_greengas" do
##      before do
##      area = @policy.present_area.areable_land
##      policy_goal = @policy.goal(:greengas)
##        @expected = ?
##      end
##      subject { @sp.policy_greengas }
##      its(:present_value) { should be_near @expected.present_value }
##      its(:future_value) { should be_near @expected.future_value }
##    end
##
##    describe "policy_biomass" do
##      before do
##      area = @policy.present_area.areable_land
##      policy_goal = @policy.goal(:biomass)
##        @expected = ?
##      end
##      subject { @sp.policy_biomass }
##      its(:present_value) { should be_near @expected.present_value }
##      its(:future_value) { should be_near @expected.future_value }
##    end
#
#
#
#    describe "policy_net_energy_import" do
#      before do
#        policy_goal = @policy.goal(:net_energy_import)
#        @expected = GqueryResult.create [[2010, 25.713336364934], [2040, 25.713336364934]]
#      end
#      subject { @sp.policy_net_energy_import }
#      its(:present_value) { should be_near @expected.present_value }
#      its(:future_value) { should be_near @expected.future_value }
#    end
#
#    describe "policy_net_electricity_import" do
#      before do
#        policy_goal = @policy.goal(:net_electricity_import)
#        @expected = GqueryResult.create [[2010, 9.84018210180452], [2040, 9.84018210180452]]
#      end
#      subject { @sp.policy_net_electricity_import }
#      its(:present_value) { should be_near @expected.present_value }
#      its(:future_value) { should be_near @expected.future_value }
#    end
#
#
  end

end

