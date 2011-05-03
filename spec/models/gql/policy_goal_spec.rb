require 'spec_helper'

# set target so that the goal will be met
def target_that_will_be_met(goal, d1990)
  case goal.key
    when :co2_emission # slightly higher % increase co2
      (goal.future_value / d1990) - 0.999
    when :renewable_percentage # renewable t <= f
      goal.future_value * 0.999
    when :electricity_cost, :total_energy_cost # .1% increase elec/heat
      0.001
    else # all other goals f < t
      goal.future_value * 1.001
  end
end

# set target so that the goal will not be met
def target_that_will_not_be_met(goal, d1990)
  case goal.key
    when :co2_emission # slightly lower % increase co2
      (goal.future_value / d1990) - 1.001
    when :renewable_percentage # renewable t <= f
      goal.future_value * 1.001
    when :electricity_cost, :total_energy_cost # .1% increase elec/heat
      -0.001
    else # all other goals t >= f
      # make value slightly negative when future_value == 0
      goal.future_value == 0 ? -0.001 : goal.future_value * 0.999
  end

end

module Gql

  describe PolicyGoal do
#
#   describe "NL 2040 Policy" do
#     before :all do
#       Current.gql = @gql = load_gql_fixture
#       load_fixtures
#     end
#
#     before :each do
#       # Current.stub!(:gql).and_return(@gql)
#       @policy = @gql.policy
#       @d1990 = @policy.present_area.co2_emission_1990
#     end
#
#     # GOALS REACHED
#
#     describe "goals reached" do
#       before do
#         @policy.goals.each { |goal| goal.user_value = target_that_will_be_met(goal, @d1990) }
#       end
#
#       specify "for a specific policy" do
#         @policy.goals.each do |goal|
#           goal.reached?.should be_true
#         end
#       end
#
#       describe "co2_emission" do
#         subject { @policy.goal(:co2_emission) }
#         its(:start_value) { should be_near(161.058616696992) }
#         its(:future_value) { should be_near(161.058404813968) }
#         # old target was % but new target will be absolute
#         # its(:target_value) { should be_near(0.0662010900394691) }
#         its(:target_value) { should be_near(161.209604813968) }
#       end
#       # when user_value = 0.0662010900394691 reached is true
#
#       describe "net_energy_import" do
#         subject { @policy.goal(:net_energy_import) }
#         its(:start_value) { should be_near(0.25713336364934) }
#         its(:future_value) { should be_near(0.970369266978593) }
#         its(:target_value) { should be_near(0.971339636245572) }
#       end
#       # when user_value = 0.971339636245572 reached is true
#
#       describe "net_electricity_import" do
#         subject { @policy.goal(:net_electricity_import) }
#         its(:start_value) { should be_near(0.0984018210180452) }
#         its(:future_value) { should be_near(0.0983978315315542) }
#         its(:target_value) { should be_near(0.0984962293630857) }
#       end
#       # when user_value = 0.0984962293630857 reached is true
#
#       describe "total_energy_cost" do
#         subject { @policy.goal(:total_energy_cost) }
#         its(:start_value) { should be_near(41.8032812103651) }
#         its(:future_value) { should be_near(41.8032812103651) }
#         its(:target_value) { should be_near(41.8451364419461) }
#       end
#       # when user_value = 0.001 reached is true
#
#       describe "electricity_cost" do
#         subject { @policy.goal(:electricity_cost) }
#         its(:start_value) { should be_near(84.9885011063692) }
#         its(:future_value) { should be_near(84.9885011063692) }
#         its(:target_value) { should be_near(85.0734896074755) }
#       end
#       # when user_value = 0.001 reached is true
#
#       describe "renewable_percentage" do
#         subject { @policy.goal(:renewable_percentage) }
#         its(:start_value) { should be_near(0.0486136111863168) }
#         its(:future_value) { should be_near(0.0486136102655253) }
#         its(:target_value) { should be_near(0.0485649966552597) }
#       end
#       # when user_value = 0.0485649966552597 reached is true
#
#       describe "onshore_land" do
#         subject { @policy.goal(:onshore_land) }
#         its(:start_value) { should be_near(0.269034521404066) }
#         its(:future_value) { should be_near(29.8601415306373) }
#         its(:target_value) { should be_near(29.8900016721679) }
#       end
#       # when user_value = 29.8900016721679 reached is true
#
#       describe "onshore_coast" do
#         subject { @policy.goal(:onshore_coast) }
#         its(:start_value) { should be_near(0.580473014523279) }
#         its(:future_value) { should be_near(9.86804124689575) }
#         its(:target_value) { should be_near(9.87790928814264) }
#       end
#       # when user_value = 9.87790928814264 reached is true
#
#       describe "offshore" do
#         subject { @policy.goal(:offshore) }
#         its(:start_value) { should be_near(0.594938130626932) }
#         its(:future_value) { should be_near(10.1139482206578) }
#         its(:target_value) { should be_near(10.1240621688785) }
#       end
#       # when user_value = 10.1240621688785 reached is true
#
#       describe "roofs_for_solar_panels" do
#         subject { @policy.goal(:roofs_for_solar_panels) }
#         its(:start_value) { should be_near(0.171000162450625) }
#         its(:future_value) { should be_near(0.456001003202207) }
#         its(:target_value) { should be_near(0.456457004205409) }
#       end
#       # when user_value = 0.456457004205409 reached is true
#
#       describe "land_for_solar_panels" do
#         subject { @policy.goal(:land_for_solar_panels) }
#         its(:start_value) { should be_near(0.0) }
#         its(:future_value) { should be_near(0.0) }
#         its(:target_value) { should be_near(0.0) }
#       end
#       # when user_value = 0.0 reached is true
#
#       describe "land_for_csp" do
#         subject { @policy.goal(:land_for_csp) }
#         its(:start_value) { should be_near(0.0) }
#         its(:future_value) { should be_near(0.0) }
#         its(:target_value) { should be_near(0.0) }
#       end
#       # when user_value = 0.0 reached is true
#
#
#     end
#
#     # GOALS NOT REACHED
#
#     describe "goals not reached" do
#       before do
#         @policy.goals.each { |goal| goal.user_value = target_that_will_not_be_met(goal, @d1990) }
#       end
#
#       specify "for a specific policy" do
#         @policy.goals.each do |goal|
#           goal.reached?.should be_false
#         end
#       end
#
#       describe "co2_emission" do
#         subject { @policy.goal(:co2_emission) }
#         # old target was % but new target will be absolute
#         # its(:target_value) { should be_near(0.0642010900394692) }
#         its(:target_value) { should be_near(160.907204813968) }
#       end
#       # when user_value = 0.0642010900394692 reached is false
#
#       describe "net_energy_import" do
#         subject { @policy.goal(:net_energy_import) }
#         its(:target_value) { should be_near(0.969398897711615) }
#       end
#       # when user_value = 0.969398897711615 reached is false
#
#       describe "net_electricity_import" do
#         subject { @policy.goal(:net_electricity_import) }
#         its(:target_value) { should be_near(0.0982994337000227) }
#       end
#       # when user_value = 0.0982994337000227 reached is false
#
#       describe "total_energy_cost" do
#         subject { @policy.goal(:total_energy_cost) }
#         its(:target_value) { should be_near(41.7615297757284) }
#       end
#       # when user_value = -0.001 reached is false
#
#       describe "electricity_cost" do
#         subject { @policy.goal(:electricity_cost) }
#         its(:target_value) { should be_near(84.9035126052628) }
#       end
#       # when user_value = -0.001 reached is false
#
#       describe "renewable_percentage" do
#         subject { @policy.goal(:renewable_percentage) }
#         its(:target_value) { should be_near(0.0486622238757908) }
#       end
#       # when user_value = 0.0486622238757908 reached is false
#
#       describe "onshore_land" do
#         subject { @policy.goal(:onshore_land) }
#         its(:target_value) { should be_near(29.8302813891067) }
#       end
#       # when user_value = 29.8302813891067 reached is false
#
#       describe "onshore_coast" do
#         subject { @policy.goal(:onshore_coast) }
#         its(:target_value) { should be_near(9.85817320564885) }
#       end
#       # when user_value = 9.85817320564885 reached is false
#
#       describe "offshore" do
#         subject { @policy.goal(:offshore) }
#         its(:target_value) { should be_near(10.1038342724372) }
#       end
#       # when user_value = 10.1038342724372 reached is false
#
#       describe "roofs_for_solar_panels" do
#         subject { @policy.goal(:roofs_for_solar_panels) }
#         its(:target_value) { should be_near(0.455545002199005) }
#       end
#       # when user_value = 0.455545002199005 reached is false
#
#       describe "land_for_solar_panels" do
#         subject { @policy.goal(:land_for_solar_panels) }
#         its(:target_value) { should be_near(-0.001) }
#       end
#       # when user_value = -0.001 reached is false
#
#       describe "land_for_csp" do
#         subject { @policy.goal(:land_for_csp) }
#         its(:target_value) { should be_near(-0.001) }
#       end
#       # when user_value = -0.001 reached is false
#
#
#     end
#
#     # test the outputs for _constraint_6.haml
#     describe "output_future_value" do
#       before do
#         @policy.goals.each { |goal| goal.user_value = target_that_will_not_be_met(goal, @d1990) }
#       end
#
#       specify { @policy.goal(:co2_emission).output_future_value.to_s.should == '+6.5<small>%</small>' }
#       specify { @policy.goal(:net_energy_import).output_future_value.to_s.should == '97.0<small>%</small>' }
#       specify { @policy.goal(:net_electricity_import).output_future_value.to_s.should == '9.8<small>%</small>' }
#       specify { @policy.goal(:total_energy_cost).output_future_value.to_s.should == '41.8' }
#       specify { @policy.goal(:electricity_cost).output_future_value.to_s.should == '84.99' }
#       specify { @policy.goal(:renewable_percentage).output_future_value.to_s.should == '4.9<small>%</small>' }
#       specify { @policy.goal(:onshore_land).output_future_value.to_s.should == '29.9<small>km2</small>' }
#       specify { @policy.goal(:onshore_coast).output_future_value.to_s.should == '9.9<small>km</small>' }
#       specify { @policy.goal(:offshore).output_future_value.to_s.should == '10.1<small>km2</small>' }
#       specify { @policy.goal(:roofs_for_solar_panels).output_future_value.to_s.should == '0.5<small>km2</small>' }
#       specify { @policy.goal(:land_for_solar_panels).output_future_value.to_s.should == '0.0<small>km2</small>' }
#       specify { @policy.goal(:land_for_csp).output_future_value.to_s.should == '0.0<small>km2</small>' }
#
#     end
#
#     describe "output_user_target" do
#       before do
#         @policy.goals.each { |goal| goal.user_value = target_that_will_not_be_met(goal, @d1990) }
#       end
#
#       specify { @policy.goal(:co2_emission).output_user_target.to_s.should == '6.4<small>%</small>' }
#       specify { @policy.goal(:net_energy_import).output_user_target.to_s.should == '96.9<small>%</small>' }
#       specify { @policy.goal(:net_electricity_import).output_user_target.to_s.should == '9.8<small>%</small>' }
#       specify { @policy.goal(:total_energy_cost).output_user_target.to_s.should == '41.76' }
#       specify { @policy.goal(:electricity_cost).output_user_target.to_s.should == '84.9' }
#       specify { @policy.goal(:renewable_percentage).output_user_target.to_s.should == '4.9<small>%</small>' }
#       specify { @policy.goal(:onshore_land).output_user_target.to_s.should == '29.8<small>km2</small>' }
#       specify { @policy.goal(:onshore_coast).output_user_target.to_s.should == '9.9<small>km</small>' }
#       specify { @policy.goal(:offshore).output_user_target.to_s.should == '10.1<small>km2</small>' }
#       specify { @policy.goal(:roofs_for_solar_panels).output_user_target.to_s.should == '0.5<small>km2</small>' }
#       specify { @policy.goal(:land_for_solar_panels).output_user_target.to_s.should == '0.0<small>km2</small>' }
#       specify { @policy.goal(:land_for_csp).output_user_target.to_s.should == '0.0<small>km2</small>' }
#
#
#     end
#
#
#   end

  end
end
