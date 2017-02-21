require 'spec_helper'

describe ConstraintsController do
  describe "on GET show" do
    let(:constraint) { FactoryGirl.create :constraint, key: 'total_primary_energy' }

    let(:response) { get(:show, params: { id: constraint.id }) }

    it { expect(response).to be_success }
    it { expect(response).to render_template(:show) }
  end
end
