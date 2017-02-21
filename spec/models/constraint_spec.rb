require 'spec_helper'

describe Constraint do
  it { is_expected.to validate_presence_of(:group) }

  Constraint::GROUPS.each do |group|
    it { is_expected.to allow_value(group).for(:group) }
  end

  it { is_expected.not_to allow_value('').for(:group) }
  it { is_expected.not_to allow_value('invalid_group').for(:group) }
end

# ----------------------------------------------------------------------------

describe Constraint, '#as_json' do
  before { FactoryGirl.create :constraint }
  subject { Constraint.first.as_json }

  it 'should remove the "constraint" root' do
    expect(subject).not_to have_key('constraint')
  end

  it { is_expected.to have_key('id') }
  it { is_expected.to have_key('key') }
  it { is_expected.to have_key('gquery_key') }
end

# ----------------------------------------------------------------------------

describe Constraint, '.for_dashboard' do
  context 'when an array of keys' do
    let(:keys) { %w( total_primary_energy co2_reduction ) }
    before do
      keys.each{|k| FactoryGirl.create :constraint, :key => k}
    end

    subject { Constraint.for_dashboard(keys) }

    it { is_expected.to be_a(Array) }
    it { expect(subject.length).to eq(keys.length) }

    it 'should return the total_primary_energy constraint first' do
      expect(subject[0]).to eql(Constraint.find_by_key(keys[0]))
    end

    it 'should return the co2_reduction constraint second' do
      expect(subject[1]).to eql(Constraint.find_by_key(keys[1]))
    end
  end

  context 'when given an array with a duplicate key' do
    let(:keys) { %w( total_primary_energy co2_reduction total_primary_energy ) }
    before do
      keys.each{|k| FactoryGirl.create :constraint, :key => k}
    end
    subject { Constraint.for_dashboard(keys) }

    it { expect(subject.length).to eq(keys.length) }
    it { is_expected.to be_a(Array) }

    it 'should return the total_primary_energy constraint first' do
      expect(subject[0]).to eql(Constraint.find_by_key(keys[0]))
    end

    it 'should return the co2_reduction constraint second' do
      expect(subject[1]).to eql(Constraint.find_by_key(keys[1]))
    end

    it 'should return the total_primary_energy constraint third' do
      expect(subject[2]).to eql(Constraint.find_by_key(keys[2]))
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

