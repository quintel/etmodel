# frozen_string_literal: true

require 'rails_helper'

describe Tab do
  describe '.' do
    subject { described_class }

    it { is_expected.to respond_to :all }
    it { is_expected.to respond_to :where }
    it { is_expected.to respond_to :find }
    it { is_expected.to respond_to :find_by_key }
    it { is_expected.to respond_to :ordered }
    it { is_expected.to respond_to :frontend }
  end

  subject { described_class.new }

  it { is_expected.to respond_to :allowed_sidebar_items }
  it { is_expected.to respond_to :sidebar_items }
  it { is_expected.to be_a AreaDependent::YModel }

  it '.index is :key' do
    expect(described_class.index).to eq(:key)
  end

  # We might want to lift these preconditions to the applications from the
  # testsuite as it provides better feedback to the modelers that way.
  describe 'YAML file' do
    subject { described_class.all }

    it 'has unique keys' do
      keys = subject.map(&:key)
      expect(keys.size).to eq(keys.uniq.size)
    end
  end
end
