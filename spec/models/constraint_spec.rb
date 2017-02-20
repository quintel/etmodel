require 'spec_helper'

describe Constraint, type: :model do
  it { should validate_presence_of(:group) }

  Constraint::GROUPS.each do |group|
    it { should allow_value(group).for(:group) }
  end

  it { should_not allow_value('').for(:group) }
  it { should_not allow_value('invalid_group').for(:group) }
end

# ----------------------------------------------------------------------------

describe Constraint, '#as_json' do
  before { FactoryGirl.create :constraint }
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
    before do
      keys.each{|k| FactoryGirl.create :constraint, :key => k}
    end

    subject { Constraint.for_dashboard(keys) }

    it { should be_a(Array) }
    it { expect(subject.length).to eq(keys.length) }

    it 'should return the total_primary_energy constraint first' do
      subject[0].should eql(Constraint.find_by_key(keys[0]))
    end

    it 'should return the co2_reduction constraint second' do
      subject[1].should eql(Constraint.find_by_key(keys[1]))
    end
  end

  context 'when given an array with a duplicate key' do
    let(:keys) { %w( total_primary_energy co2_reduction total_primary_energy ) }
    before do
      keys.each{|k| FactoryGirl.create :constraint, :key => k}
    end
    subject { Constraint.for_dashboard(keys) }

    it { expect(subject.length).to eq(keys.length) }
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
    before { FactoryGirl.create :constraint, :key => 'total_primary_energy'}
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

