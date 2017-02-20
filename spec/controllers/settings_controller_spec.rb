require 'spec_helper'

describe SettingsController, type: :controller do
  describe 'on PUT /settings', vcr: true do
    it "should update individual settings" do
      put :update, :format => :json, :use_fce => true
      response.should be_success
      session[:setting][:use_fce].to_s.should == 'true'
    end

    it "should update individual settings passed as strings" do
      put :update, :format => :json, "track_peak_load" => true
      response.should be_success
      session[:setting][:track_peak_load].to_s.should == 'true'
    end

    it "should update the charts hash" do
      put :update, :format => :json, :locked_charts => {'holder_0' => 123}
      response.should be_success
      expect(session[:setting][:locked_charts]).to eql({'holder_0' => '123'})
    end

    it "should update the charts hash" do
      put :update, :format => :json, :locked_charts => {}
      response.should be_success
      expect(session[:setting][:locked_charts]).to eql({})
    end
  end

  describe 'on PUT /settings/dashboard' do
    let(:constraints) do
      Constraint::GROUPS.each_with_object([]) do |group, c|
        c.push FactoryGirl.create(:constraint, group: group)
      end
    end

    let(:dash_settings) do
      enum = Constraint::GROUPS.to_enum

      enum.with_index.each_with_object({}) do |(group, index), c|
        c[ group ] = constraints[ index ].key
      end
    end

    # ------------------------------------------------------------------------

    context 'when given a valid setting hash' do
      it 'should return 200 OK' do
        put :update_dashboard, dash: dash_settings
        response.code.should eql('200')
      end

      it 'should return the constraints as JSON' do
        put :update_dashboard, dash: dash_settings

        parsed = JSON.parse(response.body)
        parsed.should have_key('constraints')
        parsed['constraints'].should eql(constraints.map(&:as_json))
      end

      it 'should return HTML with which to replace the dashboard' do
        put :update_dashboard, dash: dash_settings
        JSON.parse(response.body).should have_key('html')
      end

      it 'should set the preferences in the session' do
        put :update_dashboard, dash: dash_settings
        session[:dashboard].should eql(dash_settings.values)
      end
    end

    # ------------------------------------------------------------------------

    context 'when no setting hash is provided' do
      it 'should return a 400 Bad Request' do
        put :update_dashboard
        response.status.should eql(400)
      end
    end

    # ------------------------------------------------------------------------

    context 'when the setting option is not a hash' do
      it 'should return a 400 Bad Request' do
        put :update_dashboard, dash: 'invalid'
        response.status.should eql(400)
      end
    end

    # ------------------------------------------------------------------------

    context 'when given extra options' do
      it 'should not set extra keys on the session' do
        put :update_dashboard,
          dash: dash_settings.merge(another: constraints[0].key)

        session[:dashboard].should eql(dash_settings.values)
      end
    end

    # ------------------------------------------------------------------------

    context 'when given only a subset of options' do
      it 'should not accept partial assignment' do
        put :update_dashboard, dash: {
          Constraint::GROUPS[0] => constraints[0].key,
          Constraint::GROUPS[1] => constraints[1].key
        }

        response.status.should eql(400)
      end
    end

    # ------------------------------------------------------------------------

    context 'when given an invalid constraint ID' do
      it 'should return a 400 Bad Request' do
        put :update_dashboard,
          dash: dash_settings.merge(Constraint::GROUPS[0] => 0)

        response.status.should eql(400)
      end
    end

    # ------------------------------------------------------------------------

  end
end
