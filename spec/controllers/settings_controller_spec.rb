require 'spec_helper'

describe SettingsController do
  describe 'on PUT /settings/dashboard' do
    let(:constraints) { Constraint.limit(7) }

    let(:dash_settings) {
      {
      'energy'     => constraints[0].id,
      'emissions'  => constraints[1].id,
      'imports'    => constraints[2].id,
      'costs'      => constraints[3].id,
      'bio'        => constraints[4].id,
      'renewables' => constraints[5].id,
      'goals'      => constraints[6].id
    } }

    # ------------------------------------------------------------------------

    context 'when given a valid setting hash' do
      it 'should return 200 OK' do
        put :dashboard, :dash => dash_settings
        response.code.should eql('200')
      end

      it 'should return a JSON version of the dashboard settings' do
        put :dashboard, :dash => dash_settings

        response.body.length.should_not eql(0)
        JSON.parse(response.body).should eql(dash_settings)
      end

      it 'should set the preferences in the session' do
        put :dashboard, :dash => dash_settings
        session[:dashboard].should eql(dash_settings)
      end
    end

    # ------------------------------------------------------------------------

    context 'when no setting hash is provided' do
      it 'should raise no error' do
        expect { put :dashboard }.to_not raise_error
      end
    end

    # ------------------------------------------------------------------------

    context 'when the setting option is not a hash' do
      it 'should make no changes' do
        expect { put :dashboard, :dash => 'invalid' }.to_not raise_error
        session[:dashboard].should be_empty
      end
    end

    # ------------------------------------------------------------------------

    context 'when given extra options' do
      it 'should not set extra keys on the session' do
        put :dashboard, :dash => dash_settings.merge(
          :another => constraints[0].id)

        session[:dashboard].should_not have_key('another')
      end
    end

    # ------------------------------------------------------------------------

    context 'when given only a subset of options' do
      it 'should not accept partial assignment' do
        put :dashboard, :dash => {
          'energy'    => constraints[0].id,
          'emissions' => constraints[1].id
        }

        response.status.should eql(400)
      end
    end

    # ------------------------------------------------------------------------

    context 'when given an invalid constraint ID' do
      it 'should return a 400 Bad Request' do
        put :dashboard, :dash => dash_settings.merge(:energy => 0)
        response.status.should eql(400)
      end
    end

    # ------------------------------------------------------------------------

  end
end
