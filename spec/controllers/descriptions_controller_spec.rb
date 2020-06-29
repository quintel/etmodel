# frozen_string_literal: true

require 'rails_helper'

describe DescriptionsController do
  render_views

  let(:chart) { OutputElement.all.first }
  let(:description) { chart.description }

  describe "#charts" do
    context 'when the chart exists' do
      before { get :charts, params: { id: chart.key } }

      it { expect(response).to be_successful }
      it { expect(response).to render_template(:show) }
      it { expect(response.body).not_to be_empty }
    end

    context 'when the chart does not exist' do
      before { get :charts, params: { id: 'four_oh_four' } }

      it { expect(response).not_to be_successful }
      it { expect(response.code).to eq('404') }
    end
  end
end
