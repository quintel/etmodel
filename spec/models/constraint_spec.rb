require 'spec_helper'

# test the outputs for _constraint_6.haml
describe "output" do
#  before do
#    Current.gql = @gql = load_gql_fixture
#    Current.stub!(:gql).and_return(@gql)
#    @constraints = Constraint.all
#  end
#
#  def find_constraint(key)
#    @constraints.detect {|c| c.key == key}
#  end
#
#  describe "total_primary_energy" do
#    subject { find_constraint(:total_primary_energy) }
#    its(:output) { should == '0.0<small>%</small>' }
#  end
#
#  describe "co2_reduction" do
#    subject { find_constraint(:co2_reduction) }
#    its(:output) { should == '+6.5<small>%</small>' }
#  end
#
#  describe "net_energy_import" do
#    subject { find_constraint(:net_energy_import) }
#    its(:output) { should == '97.0<small>%</small>' }
#  end
#  describe "total_energy_cost" do
#      subject { find_constraint(:total_energy_cost) }
#      its(:output) { should == '<small>' + EURO_SIGN + '</small> 41.8' }
#  end
#  describe "not_shown" do
#        subject { find_constraint(:not_shown) }
#        its(:output) { should == '0.54<small>xNL</small>' }
#  end
#  describe "renewable_percentage" do
#          subject { find_constraint(:renewable_percentage) }
#          its(:output) { should == '4.9<small>%</small>' }
#  end
#  describe "targets_met" do
#            subject { find_constraint(:targets_met) }
#            its(:output) { should == '0 / 12' }
#  end
#
end


# == Schema Information
#
# Table name: constraints
#
#  id             :integer(4)      not null, primary key
#  key            :string(255)
#  name           :string(255)
#  extended_title :string(255)
#  query          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

