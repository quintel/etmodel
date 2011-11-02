require 'spec_helper'

describe ConstraintsController do
  render_views
  
  describe "on GET show" do
    before { get :show, :id => 1 }
  
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end
end
