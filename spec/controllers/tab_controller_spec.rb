require 'spec_helper'

describe TabController do
  render_views

  describe "demand page" do
    fixtures :tabs, :sidebar_items, :slides, :output_elements, :output_element_types

    it "should work" do
      get :show, :tab => 'demand'
      response.should be_success
      response.should render_template('show')
    end
  end
end
