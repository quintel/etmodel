require 'spec_helper'

describe ConstraintsController do
  describe "on GET show" do
    before { get :show, :id => 1 }
    
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  describe "on GET iframe" do
    before { get :iframe, :id => 1 }
    
    it { should respond_with(:success) }
    it { should render_template(:iframe) }
  end
end
