require 'spec_helper'


describe UserLogicHelper do
  include UserLogicHelper
  
  before(:each) do
    @options = {:environment => {:country => "en", :region => "ame"}}
  end
  
  context "output" do
    it "should show something when condition is true" do
      text = "<filter conditions='country=en'>show this</filter>"
      formatted = format_with_user_logic(text, @options)
      formatted.should == "show this"
    end
    
    it "should not matter if there is whitespace" do
      text = "<filter conditions='country=en'>show this</filter>"
      formatted = format_with_user_logic(text, @options)
      formatted.should == "show this"
    end
    
    it "should hide something when condition is false" do
      text = "<filter conditions='country!=en'>show this not</filter>"
      formatted = format_with_user_logic(text, @options)
      formatted.should == ""
    end
    
    
    it "should be able to have multiple conditions" do
      text = "<filter conditions='country==en and region==ame'>show this</filter>"
      formatted = format_with_user_logic(text, @options)
      formatted.should == "show this"
    end
    
    it "should be able to have multiple conditions" do
      text = "<filter conditions='country==en and region!=ame'>show this</filter>"
      formatted = format_with_user_logic(text, @options)
      formatted.should == ""
    end
    
    it "should have a method #default_allowed_keys" do
      default_allowed_keys.should_not be_nil
    end    
  end
  

  context "helper methods" do
    it "should find the xml when there are more than one filters" do
      filters = find_filter_xml("asdasdasd<filter='asddsa'>asdasd</filter>asdasdasd<filter on='asd'>showthis</filter>")
      filters.should == ["<filter='asddsa'>asdasd</filter>", "<filter on='asd'>showthis</filter>"]
    end
    
    it "should return something" do
      evaluate_filter_xml("<filter conditions='country=en'>asdasd</filter>", :environment => {:country => 'en'}).should == "asdasd"
      evaluate_filter_xml("<filter conditions='country=nl'>asdasd</filter>", :environment => {:country => 'en'}).should == ""
      evaluate_filter_xml("<filter conditions='country=nl'>asdasd</filter>", :environment => {:country => 'nl'}).should == "asdasd"
    end
    
    context "#evaluate_conditions" do  
      it "should evaluate conditions" do
        evaluate_conditions("country=en", :environment => {:country => 'en'}).should == true
        evaluate_conditions("country==en", :environment => {:country => 'en'}).should == true
        evaluate_conditions("country=nl", :environment => {:country => 'en'}).should == false
        evaluate_conditions("country!=en", :environment => {:country => 'nl'}).should == true
        evaluate_conditions("country=en or country=nl", :environment => {:country => 'en'}).should == true
        evaluate_conditions("country=en and country=nl", :environment => {:country => 'en'}).should == false
        evaluate_conditions("country=en or country=nl", :environment => {:country => 'en'}).should == true
      end
    end
    
  end
end
