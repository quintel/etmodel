require 'spec_helper'

describe ServerConfig do
  describe "#new" do
    context "defaults" do
      before do
        @server_config = ServerConfig.new
      end
      subject { @server_config }
      ServerConfig.default_attributes.each do |key, default|
        its(key) { should == default }
      end
    end
  end
  
  describe "ServerConfig.from_file" do
    before do
      @server_config = ServerConfig.from_file(File.join(Rails.root, 'spec/fixtures/server_configs/default.yml'))
    end
    subject { @server_config }
    its(:root_page) { should == '/pages/default' }
    its(:whitelist_file) { should == nil }
  end
  
  
  describe "ServerConfig.from_config" do
    context "with testing config" do
      before do
        @server_config = ServerConfig.from_config(:testing)
      end
      subject { @server_config }
      its(:root_page) { should == nil }
    end
    
    context "with nil config" do
      before do
        @server_config = ServerConfig.from_config(nil)
      end
      subject { @server_config }
      its(:root_page) { should == nil }
    end
    
    
    context "with nil config" do
      before do
        @server_config = ServerConfig.from_config(nil)
      end
      subject { @server_config }
      its(:root_page) { should == nil }
    end
  end
  
  
  
end
