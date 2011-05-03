require 'spec_helper'

describe Current do


  describe "already_shown" do
    before {
      Current.session['already_shown'] = nil
    }
    context "not shown" do
      specify { Current.already_shown?('demand/intro').should be_false}
    end
    context "already shown" do
      before { Current.already_shown?('demand/intro') }
      specify { Current.already_shown?('demand/intro').should be_true}
    end
  end
  
  
  describe "#server_config" do
    context "nothing set" do      
      before do
        Current.session[:server_config] = nil
        ENV['SERVER_CONFIG'] = nil
      end

      subject {Current.instance.server_config}
      it {should_not be_nil}
      its(:name) { should == :default}
    end
    
    context "ENV['SERVER_CONFIG'] is set" do      
      before do
        Current.session[:server_config] = nil
        ENV['SERVER_CONFIG'] = "testing"
      end
      subject {Current.instance.server_config}
      it {should_not be_nil}
      its(:name) { should == :testing}
    end
    
    
    context "SERVER_CONFIG is defined" do      
      before do
        Current.session[:server_config] = nil
        ENV['SERVER_CONFIG'] = "testing"
      end
      subject {Current.instance.server_config}
      it {should_not be_nil}
      its(:name) { should == :testing}
    end
    
    
    context "Subdomain set" do
      before do
        Current.session[:server_config] = nil
        ENV['SERVER_CONFIG'] = nil
        Current.subdomain = "touchscreen"
      end
      
      subject {Current.instance.server_config}
      it {should_not be_nil}
      its(:name) { should == :touchscreen}
    end
            
  end
  
  describe "gql_calculated?" do
    context "without gql" do
      before { Current.gql = nil }
      specify { Current.gql_calculated?.should be_false}
    end
    context "with uncalculated gql" do
      before { Current.gql = mock_model(Gql::Gql, :calculated? => false) }
      specify { Current.gql_calculated?.should be_false}
    end
    context "with calculated gql" do
      before { Current.gql = mock_model(Gql::Gql, :calculated? => true) }
      specify { Current.gql_calculated?.should be_true}
    end
  end  
end
