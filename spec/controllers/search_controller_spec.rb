require 'spec_helper'

describe SearchController do
  render_views

  it "should run a search" do
    pending
    get :index, :q => 'foo'
    response.should be_success
    response.should render_template(:index)
  end
end
