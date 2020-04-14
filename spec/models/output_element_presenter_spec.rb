require 'rails_helper'

RSpec.describe OutputElementPresenter do
  let(:oe) do
    OutputElement.all.first
  end

  let(:renderer) { ->(*) {} }
  let(:json)     { OutputElementPresenter.present(oe, renderer) }

  describe 'attributes' do
    it 'are present' do
      expect(json).to have_key(:attributes)
    end

    OutputElementPresenter::ATTRIBUTES.each_key do |attr|
      it "includes #{ attr.inspect }" do
        expect(json[:attributes]).to have_key(attr)
      end
    end

    it 'includes the translated name' do
      expect(json[:attributes][:name])
        .to eq(I18n.t(
          :'output_elements.use_of_final_electricity_demand_in_households'
        ))
    end
  end

  it 'includes the element series' do
    expect(json[:series].length).to eq(oe.output_element_series.size)
  end

  context 'when the element defines a template' do
    before { allow(oe).to receive(:template).and_return('abc') }

    let!(:renderer) do
      renderer = spy('renderer')

      expect(renderer).to receive(:call)
        .with(partial: 'abc', locals: { output_element: oe })
        .and_return('Hello, world.')

      renderer
    end

    it 'includes the template with the JSON' do
      expect(json[:html]).to eq('Hello, world.')
    end
  end

  context 'when the element does not define a template' do
    before { allow(oe).to receive(:template).and_return(nil) }

    let!(:renderer) do
      renderer = spy('renderer')
      expect(renderer).to_not receive(:call)
      renderer
    end

    it 'is includes no template with the JSON' do
      expect(json[:html]).to be_nil
    end
  end

  describe '.collection' do
    let(:other) { OutputElement.all.second }

    it 'presents multiple elements' do
      json = OutputElementPresenter.collection([oe, other], ->(*) {})

      expect(json).to have_key(oe.id)
      expect(json).to have_key(other.id)
    end
  end
end
