require 'spec_helper'

describe "loading a different country", :js => true, :vcr => true do
  fixtures :tabs, :sidebar_items, :slides, :output_elements, :output_element_types

  it "should create a new scenario from a preset" do
    visit root_path
    # save_and_open_page
    click_link "Start a new scenario"
    select 'Germany', :from => 'area_code'
    click_button 'Start'

    page.should have_content('Household energy demand')

    settings = page.evaluate_script('App.settings.toJSON()')

    settings['area_code'].should == 'de'
    settings['end_year'].should == 2050

    new_scenario_id = settings['api_session_id']
    remote_scenario = Api::Scenario.find new_scenario_id

    remote_scenario.end_year.should == 2050
    remote_scenario.area_code.should == 'de'
  end
end
