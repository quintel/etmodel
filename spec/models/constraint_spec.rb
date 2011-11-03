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

# ----------------------------------------------------------------------------

describe Constraint do
  it { should validate_presence_of(:group) }

  Constraint::GROUPS.each do |group|
    it { should allow_value(group).for(:group) }
  end

  it { should_not allow_value('').for(:group) }
  it { should_not allow_value('invalid_group').for(:group) }
end

# ----------------------------------------------------------------------------

describe Constraint, '#as_json' do
  subject { Constraint.first.as_json }

  it 'should remove the "constraint" root' do
    subject.should_not have_key('constraint')
  end

  it { should have_key('id') }
  it { should have_key('key') }
  it { should have_key('gquery_key') }
end

# ----------------------------------------------------------------------------

describe Constraint, '.for_dashboard' do
  context 'when an array of keys' do
    let(:keys) { %w( total_primary_energy co2_reduction ) }
    subject { Constraint.for_dashboard(keys) }

    it { should have(keys.length).constraints }
    it { should be_a(Array) }

    it 'should return the total_primary_energy constraint first' do
      subject[0].should eql(Constraint.find_by_key(keys[0]))
    end

    it 'should return the co2_reduction constraint second' do
      subject[1].should eql(Constraint.find_by_key(keys[1]))
    end
  end

  context 'when given an array with a duplicate key' do
    let(:keys) { %w( total_primary_energy co2_reduction total_primary_energy ) }
    subject { Constraint.for_dashboard(keys) }

    it { should have(keys.length).constraints }
    it { should be_a(Array) }

    it 'should return the total_primary_energy constraint first' do
      subject[0].should eql(Constraint.find_by_key(keys[0]))
    end

    it 'should return the co2_reduction constraint second' do
      subject[1].should eql(Constraint.find_by_key(keys[1]))
    end

    it 'should return the total_primary_energy constraint third' do
      subject[2].should eql(Constraint.find_by_key(keys[2]))
    end
  end

  context 'when given an array with an invalid key' do
    let(:keys) { %w( total_primary_energy does_not_exist ) }

    it 'should raise an error' do
      expect { Constraint.for_dashboard(keys) }.to \
        raise_error(Constraint::NoSuchConstraint, /does_not_exist/)
    end
  end

  context 'when given an array with a blank key' do
    let(:keys) { [ 'total_primary_energy', '' ] }

    it 'should raise an error' do
      expect { Constraint.for_dashboard(keys) }.to \
        raise_error(Constraint::IllegalConstraintKey)
    end
  end

  context 'when given an array with a nil key' do
    let(:keys) { [ 'total_primary_energy', nil ] }

    it 'should raise an error' do
      expect { Constraint.for_dashboard(keys) }.to \
        raise_error(Constraint::IllegalConstraintKey)
    end
  end

end

