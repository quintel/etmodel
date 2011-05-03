require 'spec_helper'

module Gql

describe GqueryCleanerParser do
  describe "#clean" do
    it "should remove whitespace" do
      str = GqueryCleanerParser.clean("foo bar\t\n\r\n\t baz")
      str.should == "foobarbaz"
    end

    it "should remove comments" do
      str = GqueryCleanerParser.clean("foo/*comment*/b*a/r/*secondcomment*/baz")
      str.should == "foob*a/rbaz"
    end
  end
end

end# Gql
