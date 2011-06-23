require 'spec_helper'

# TODO: add mock_http, otherwise the tests fail if a local ETE
# is not running
describe Api::Client do
  pending
  # describe "session_id fetching" do
  #   before { @client = Api::Client.new }
  #   it "should fetch the session_id if missing" do
  #     @client.api_session_id.should be_nil
  #     @client.simple_query("V(1.0)")
  #     @client.api_session_id.should_not be_nil
  #   end
  #
  #   it "should not fetch a new session_id if present" do
  #     @client.api_session_id = 123
  #     @client.should_not_receive(:fetch_session_id)
  #     @client.simple_query("V(1.0)")
  #   end
  # end
  #
  # describe "simple queries" do
  #   before do
  #     @client = Api::Client.new
  #   end
  #
  #   it "should return the correct value for a scalar query" do
  #     response = @client.simple_query("present:V(1.0)")
  #     response.should == 1.0
  #   end
  #
  #   it "should return the correct value for a year => value query" do
  #     response = @client.simple_query("V(1.0)")
  #     response.should == {2010 => 1.0, 2040 => 1.0}
  #   end
  # end
end