require 'spec_helper'

describe ConstraintsController do
  render_views
  
  describe "on GET show" do
    before { get :show, :id => 1 }
  
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  # DEBT: test other popups. They require a huge setup, though
  [1,2,4,6].each do |i|
    describe "on GET iframe/#{i}" do
      before do
        Current.setting.stub_chain(:api_session_key).and_return(1234)
        get :iframe, :id => i
      end
    
      it { should respond_with(:success) }
      it { should render_template(:iframe) }
      it { should render_template("constraint_#{i}") }
    end
  end
end
