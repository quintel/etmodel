require 'spec_helper'

describe SettingsController do
  describe 'on PUT /settings/dashboard' do
    let(:dash_settings) { {
      'energy'     => 1,
      'emissions'  => 2,
      'imports'    => 3,
      'costs'      => 4,
      'bio'        => 5,
      'renewables' => 6,
      'goals'      => 7
    } }

    it 'should return 200 OK' do
      put :dashboard, :dash => dash_settings
      response.code.should eql('200')
    end

    it 'should set the preferences in the session' do
      put :dashboard, :dash => dash_settings
      session[:dashboard].should eql(dash_settings)
    end

    it 'should do nothing when no settings are provided' do
      expect { put :dashboard }.to_not raise_error
    end

    it 'should do nothing when settings is not a hash' do
      expect { put :dashboard, :dash => 'invalid' }.to_not raise_error
      session[:dashboard].should be_empty
    end

    it 'should not set extra keys on the session' do
      put :dashboard, :dash => dash_settings.merge(:another => 8)
      session[:dashboard].should_not have_key('another')
    end

    it 'should accept partial assignment' do
      put :dashboard, :dash => dash_settings

      new_settings = { 'energy' => 8, 'emissions' => 9 }
      put :dashboard, :dash => new_settings

      session[:dashboard][:energy].should     eql(8)
      session[:dashboard][:emissions].should  eql(9)
      session[:dashboard][:imports].should    eql(3)
      session[:dashboard][:costs].should      eql(4)
      session[:dashboard][:bio].should        eql(5)
      session[:dashboard][:renewables].should eql(6)
      session[:dashboard][:goals].should      eql(7)
    end
  end
end
