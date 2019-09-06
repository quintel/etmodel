# frozen_string_literal: true

require 'rails_helper'

describe Embeds::PicoArea, vcr: true do
  let(:nl) { described_class.find_by_area_code 'nl' }
  let(:municipality) { described_class.find_by_area_code 'GM0599_rotterdam' }
  let(:province) { described_class.find_by_area_code 'PV24_flevoland' }
  let(:neighborhood) { described_class.find_by_area_code 'BU00141102_de_hunze' }
  let(:uk) {described_class.find_by_area_code 'uk' }

  describe '.find_by_area_code' do
    subject { nl }
    it { is_expected.to be_a described_class }
  end

  describe '#methods' do
    subject { nl.methods }
    it do
      api_area_methods = Api::Area.first.methods - Object.new.methods
      is_expected.to include(*api_area_methods)
    end
  end

  describe '#type' do
    context 'with a municipality' do
      subject { municipality.type }
      it { is_expected.to eq :gemeente }
    end

    context 'with a province' do
      subject { province.type }
      it { is_expected.to eq :provincie }
    end

    context 'with the netherlands' do
      subject { nl.type }
      it { is_expected.to eq :land }
    end

    # Unsupported so fall-back to country
    context 'with a neighborhood' do
      subject { neighborhood.type }
      it { is_expected.to eq :land }
    end
  end

  describe '#area_name' do
    context 'with rotterdam' do
      subject { municipality.area_name }
      it { is_expected.to eq 'Rotterdam' }
    end

    context 'with flevoland' do
      subject { province.area_name }
      it { is_expected.to eq 'Flevoland' }
    end

    context 'with the netherlands' do
      subject { nl.area_name }
      it { is_expected.to eq 'Nederland' }
    end

    # Unsupported so fall-back to netherlands
    context 'with a non municipalityor province' do
      subject { neighborhood.area_name }
      it { is_expected.to eq 'Nederland' }
    end
  end

  describe 'supported?' do
    context 'with an unsupported location' do
      subject { uk.supported? }
      it { is_expected.to be_falsey }
    end

    context 'with a supported_location' do
      subject { nl.supported? }
      it { is_expected.to be_truthy }
    end
  end
end
