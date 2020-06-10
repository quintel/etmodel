require 'rails_helper'

describe OutputElementsController, vcr: true do
  describe "#index" do
    it "should render the page correctly" do
      get :index
      expect(response).to be_successful
      expect(response).to render_template(:index)
    end
  end

  describe '#show' do
    let!(:output_element) { OutputElement.all.first }

    context 'with a key' do
      before { get(:show, params: { key: output_element.key }) }

      it 'responds successfully' do
        expect(response.status).to eq(200)
      end

      it 'assigns the output element' do
        expect(assigns(:chart)).to eq(output_element)
      end

      it 'responds with the chart attributes' do
        expect(JSON.parse(response.body)['attributes']).to include(
          'key' => output_element.key
        )
      end
    end

    context 'with an invalid key' do
      it 'responds 404 Not Found' do
        expect(get(:show, params: { key: 'nope' }).status).to eq(404)
      end
    end
  end # #show
end
