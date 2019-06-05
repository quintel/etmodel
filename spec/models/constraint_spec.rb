require 'rails_helper'

describe Constraint do
  it { is_expected.to validate_presence_of(:group) }

  Constraint::GROUPS.each do |group|
    it { is_expected.to allow_value(group).for(:group) }
  end

  it { is_expected.not_to allow_value('').for(:group) }
  it { is_expected.not_to allow_value('invalid_group').for(:group) }

  describe '#as_json' do
    let(:json) { described_class.first.as_json }

    before { FactoryBot.create(:constraint) }

    it 'removes the "constraint" root' do
      expect(json).not_to have_key('constraint')
    end

    it { expect(json).to have_key('id') }
    it { expect(json).to have_key('key') }
    it { expect(json).to have_key('gquery_key') }
  end

  describe '.for_dashboard' do
    let!(:default_constraints) do
      [FactoryBot.create(:constraint, position: 0)]
    end

    let(:constraints) { described_class.for_dashboard(keys) }

    context 'when an array of keys' do
      let(:keys) { %w[total_primary_energy co2_reduction] }

      before do
        keys.each { |k| FactoryBot.create(:constraint, key: k) }
      end

      it 'returns the same as for_dashboard!' do
        expect(constraints).to eq(described_class.for_dashboard!(keys))
      end
    end

    context 'when given an invalid key' do
      let(:keys) { %w[nope] }

      it 'returns the default constraints' do
        expect(constraints).to eq(default_constraints)
      end
    end

    context 'when given an empty key' do
      let(:keys) { [''] }

      it 'returns the default constraints' do
        expect(constraints).to eq(default_constraints)
      end
    end
  end

  describe '.for_dashboard!' do
    let(:constraints) { described_class.for_dashboard!(keys) }

    context 'when an array of keys' do
      let(:keys) { %w[total_primary_energy co2_reduction] }

      before do
        keys.each { |k| FactoryBot.create(:constraint, key: k) }
      end

      it { expect(constraints.length).to eq(keys.length) }

      it 'returns the total_primary_energy constraint first' do
        expect(constraints[0]).to eql(described_class.find_by_key(keys[0]))
      end

      it 'returns the co2_reduction constraint second' do
        expect(constraints[1]).to eql(described_class.find_by_key(keys[1]))
      end
    end

    context 'when requesting keys in the opposite order to insertion' do
      let(:keys) { %w[co2_reduction total_primary_energy] }

      before do
        keys.reverse_each { |k| FactoryBot.create(:constraint, key: k) }
      end

      it { expect(constraints.length).to eq(keys.length) }

      it 'returns the co2_reduction constraint first' do
        expect(constraints[0]).to eql(described_class.find_by_key(keys[0]))
      end

      it 'returns the total_primary_energy constraint second' do
        expect(constraints[1]).to eql(described_class.find_by_key(keys[1]))
      end
    end

    context 'when given an array with a duplicate key' do
      let(:keys) { %w[total_primary_energy co2_reduction total_primary_energy] }

      before do
        FactoryBot.create(:constraint, key: 'total_primary_energy')
        FactoryBot.create(:constraint, key: 'co2_reduction')
      end

      it { expect(constraints.length).to eq(2) }

      it 'returns the total_primary_energy constraint first' do
        expect(constraints[0]).to eql(described_class.find_by_key(keys[0]))
      end

      it 'returns the co2_reduction constraint second' do
        expect(constraints[1]).to eql(described_class.find_by_key(keys[1]))
      end

      it 'returns nothing third' do
        expect(constraints[2]).to be_nil
      end
    end

    context 'when given an array with an invalid key' do
      let(:keys) { %w[total_primary_energy does_not_exist] }

      before { FactoryBot.create(:constraint, key: 'total_primary_energy') }

      it 'raises an error' do
        expect { constraints }
          .to raise_error(Constraint::NoSuchConstraint, /does_not_exist/)
      end
    end

    context 'when given an array with a blank key' do
      let(:keys) { ['total_primary_energy', ''] }

      it 'raises an error' do
        expect { constraints }.to raise_error(Constraint::IllegalConstraintKey)
      end
    end

    context 'when given an array with a nil key' do
      let(:keys) { ['total_primary_energy', nil] }

      it 'raise an error' do
        expect { constraints}.to raise_error(Constraint::IllegalConstraintKey)
      end
    end
  end
end
