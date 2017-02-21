require 'spec_helper'

describe PredictionsController do
  let(:prediction) { FactoryGirl.create :prediction}

  before do
    allow_any_instance_of(Setting).to receive(:area_code).and_return('nl')
  end

  describe "GET index" do
    before do
      get :index, xhr: true, params: {
        input_element_id: prediction.input_element.id
      }
    end

    it { expect(response).to be_success }
    it { expect(response).to render_template :index }
  end

  describe "GET show" do
    before do
      get :show, xhr: true, params: { id: prediction.id }
    end

    it { expect(response).to be_success }
    it { expect(response).to render_template :show }
  end

  describe "GET share" do
    before do
      get :share, params: { id: prediction.id }
    end

    it { expect(response).to be_success }
    it { expect(response).to render_template :index}
  end
end
