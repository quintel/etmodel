require 'spec_helper'

describe SettingsController do
  describe 'on PUT /settings/dashboard' do
    let(:constraints) do
      Constraint::GROUPS.each_with_object([]) do |group, c|
        c.push Constraint.where(:group => group).first
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
        put :dashboard, dash: dash_settings
        response.code.should eql('200')
      end

      it 'should return a JSON version of the dashboard settings' do
        put :dashboard, dash: dash_settings

        response.body.length.should_not eql(0)
        JSON.parse(response.body).should eql(dash_settings.values)
      end

      it 'should set the preferences in the session' do
        put :dashboard, dash: dash_settings
        session[:dashboard].should eql(dash_settings.values)
      end
    end

    # ------------------------------------------------------------------------

    context 'when no setting hash is provided' do
      it 'should return a 400 Bad Request' do
        put :dashboard
        response.status.should eql(400)
      end
    end

    # ------------------------------------------------------------------------

    context 'when the setting option is not a hash' do
      it 'should return a 400 Bad Request' do
        put :dashboard, dash: 'invalid'
        response.status.should eql(400)
      end
    end

    # ------------------------------------------------------------------------

    context 'when given extra options' do
      it 'should not set extra keys on the session' do
        put :dashboard, dash: dash_settings.merge(another: constraints[0].key)
        session[:dashboard].should eql(dash_settings.values)
      end
    end

    # ------------------------------------------------------------------------

    context 'when given only a subset of options' do
      it 'should not accept partial assignment' do
        put :dashboard, dash: {
          Constraint::GROUPS[0] => constraints[0].key,
          Constraint::GROUPS[1] => constraints[1].key
        }

        response.status.should eql(400)
      end
    end

    # ------------------------------------------------------------------------

    context 'when given an invalid constraint ID' do
      it 'should return a 400 Bad Request' do
        put :dashboard, dash: dash_settings.merge(Constraint::GROUPS[0] => 0)
        response.status.should eql(400)
      end
    end

    # ------------------------------------------------------------------------

  end
end
