# frozen_string_literal: true

require 'rails_helper'

describe DashboardItem do
  describe '#as_json' do
    let(:json) { described_class.all.first.as_json }

    it { expect(json).to have_key('key') }
    it { expect(json).to have_key('gquery_key') }
  end

  describe '.for_dashboard' do
    let!(:default_dashboard_items) do
      described_class.default
    end

    let(:dashboard_items) { described_class.for_dashboard(keys) }

    context 'when an array of keys' do
      let(:keys) { %w[total_primary_energy co2_reduction] }

      it 'returns the same as for_dashboard!' do
        expect(dashboard_items).to eq(described_class.for_dashboard!(keys))
      end
    end

    context 'when given an invalid key' do
      let(:keys) { %w[nope] }

      it 'returns the default dashboard_items' do
        expect(dashboard_items).to eq(default_dashboard_items)
      end
    end

    context 'when given an empty key' do
      let(:keys) { [''] }

      it 'returns the default dashboard_items' do
        expect(dashboard_items).to eq(default_dashboard_items)
      end
    end
  end

  describe '.for_dashboard!' do
    let(:dashboard_items) { described_class.for_dashboard!(keys) }

    context 'when an array of keys' do
      let(:keys) { %w[total_primary_energy co2_reduction] }

      it { expect(dashboard_items.length).to eq(keys.length) }

      it 'returns the total_primary_energy dashboard_item first' do
        expect(dashboard_items[0]).to eql(described_class.find(keys[0]))
      end

      it 'returns the co2_reduction dashboard_item second' do
        expect(dashboard_items[1]).to eql(described_class.find(keys[1]))
      end
    end

    context 'when requesting keys in the opposite order to interface file' do
      let(:keys) { %w[co2_reduction total_primary_energy] }

      it { expect(dashboard_items.length).to eq(keys.length) }

      it 'returns the co2_reduction dashboard_item first' do
        expect(dashboard_items[0]).to eql(described_class.find(keys[0]))
      end

      it 'returns the total_primary_energy dashboard_item second' do
        expect(dashboard_items[1]).to eql(described_class.find(keys[1]))
      end
    end

    context 'when given an array with a duplicate key' do
      let(:keys) { %w[total_primary_energy co2_reduction total_primary_energy] }

      it { expect(dashboard_items.length).to eq(2) }

      it 'returns the total_primary_energy dashboard_item first' do
        expect(dashboard_items[0]).to eql(described_class.find(keys[0]))
      end

      it 'returns the co2_reduction dashboard_item second' do
        expect(dashboard_items[1]).to eql(described_class.find(keys[1]))
      end

      it 'returns nothing third' do
        expect(dashboard_items[2]).to be_nil
      end
    end

    context 'when given an array with an invalid key' do
      let(:keys) { %w[total_primary_energy does_not_exist] }

      it 'raises an error' do
        expect { dashboard_items }
          .to raise_error(DashboardItem::NoSuchDashboardItem, /does_not_exist/)
      end
    end

    context 'when given an array with a blank key' do
      let(:keys) { ['total_primary_energy', ''] }

      it 'raises an error' do
        expect { dashboard_items }.to raise_error(DashboardItem::IllegalDashboardItemKey)
      end
    end

    context 'when given an array with a nil key' do
      let(:keys) { ['total_primary_energy', nil] }

      it 'raise an error' do
        expect { dashboard_items }.to raise_error(DashboardItem::IllegalDashboardItemKey)
      end
    end
  end
end
