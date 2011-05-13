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
end
