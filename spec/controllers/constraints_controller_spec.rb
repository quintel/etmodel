require 'spec_helper'

describe ConstraintsController do
  render_views
  
  describe "on GET show" do
    before { get :show, :id => 1 }
  
    it { should respond_with(:success) }
    it { should render_template(:show) }
  end

  1.upto(8) do |i|
    describe "on GET iframe/#{i}" do
      before { get :iframe, :id => i }
    
      it { should respond_with(:success) }
      it { should render_template(:iframe) }
      it { should render_template("constraint_#{i}") }
    end
  end
end
