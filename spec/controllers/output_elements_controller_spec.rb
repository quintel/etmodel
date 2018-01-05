require 'rails_helper'

describe OutputElementsController, vcr: true do
  describe "#index" do
    it "should render the page correctly" do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

  describe '#show' do
    let!(:output_element) { FactoryBot.create(:output_element, key: 'abc') }

    context 'with a numeric ID' do
      before { get(:show, params: { id: output_element.id }) }

      it 'responds successfully' do
        expect(response.status).to eq(200)
      end

      it 'assigns the output element' do
        expect(assigns(:chart)).to eq(output_element)
      end

      it 'responds with the chart attributes' do
        expect(JSON.parse(response.body)['attributes']).to include(
          'id'  => output_element.id,
          'key' => output_element.key
        )
      end
    end

    context 'with an invalid numeric ID' do
      it 'responds 404 Not Found' do
        expect { get(:show, params: { id: '0' }) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with a key' do
      before { get(:show, params: { id: output_element.key }) }

      it 'responds successfully' do
        expect(response.status).to eq(200)
      end

      it 'assigns the output element' do
        expect(assigns(:chart)).to eq(output_element)
      end

      it 'responds with the chart attributes' do
        expect(JSON.parse(response.body)['attributes']).to include(
          'id'  => output_element.id,
          'key' => output_element.key
        )
      end
    end

    context 'with an invalid key' do
      it 'responds 404 Not Found' do
        expect { get(:show, params: { id: 'nope' }) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end # #show
end
