require 'spec_helper'
require 'fakeweb'

describe ProxyController do
  before do
    @fake_url = "#{APP_CONFIG[:api_url]}/foo"
  end

  it "should proxy GET requests" do
    FakeWeb.register_uri(:get, @fake_url, body: 'Hi!')
    get :index, url: 'foo'
    response.should be_success
  end

  it "should proxy POST requests" do
    FakeWeb.register_uri(:post, @fake_url, body: 'Hi!')
    post :index, url: 'foo', foo: 'bar'
    response.should be_success
  end

  it "should proxy PUT requests" do
    FakeWeb.register_uri(:put, @fake_url, body: 'Hi!')
    put :index, url: 'foo', foo: 'bar'
    response.should be_success
  end

  it "should proxy DELETE requests" do
    FakeWeb.register_uri(:delete, @fake_url, body: 'Hi!')
    delete :index, url: 'foo', foo: 'bar'
    response.should be_success
  end

  it "should not alter the HTTP status code" do
    FakeWeb.register_uri(:get, @fake_url, body: 'Hi!', :status => [404, 'Not Found'])
    get :index, url: 'foo', foo: 'bar'
    response.status.should eql(404)
  end
end
