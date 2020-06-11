# frozen_string_literal: true

require 'rails_helper'

describe DashboardItemsController do
  describe 'on GET show' do
    let(:dashboard_items) { DashboardItem.all.first }

    let(:response) { get(:show, params: { id: dashboard_items.key }) }

    it { expect(response).to be_successful }
    it { expect(response).to render_template(:show) }
  end
end
