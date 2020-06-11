require 'rails_helper'

describe SettingsController do
  describe 'on PUT /settings', vcr: true do
    it "should update individual settings" do
      put :update, params: { format: :json, use_fce: true }
      expect(response).to be_successful
      expect(session[:setting][:use_fce].to_s).to eq('true')
    end

    it "should update individual settings passed as strings" do
      put :update, params: { format: :json, "use_fce" => true }
      expect(response).to be_successful
      expect(session[:setting][:use_fce].to_s).to eq('true')
    end

    it "should update the charts hash" do
      put :update, params: {
        format: :json, locked_charts: [123]
      }

      expect(response).to be_successful
      expect(session[:setting][:locked_charts]).to eql(['123'])
    end

    it "should update the charts hash" do
      put :update, params: { format: :json, locked_charts: [] }
      expect(response).to be_successful
      expect(session[:setting][:locked_charts]).to eql([])
    end
  end

  describe 'on PUT /settings/dashboard' do
    let(:dashboard_items) do
      DashboardItem::GROUPS.each_with_object([]) do |group, d|
        d.push(DashboardItem.where(group: group)[0])
      end
    end

    let(:dash_settings) do
      DashboardItem::GROUPS
        .map
        .with_index { |value, index| [value, dashboard_items[index].key] }
        .to_h
    end

    # ------------------------------------------------------------------------

    context 'when given a valid setting hash' do
      it 'should return 200 OK' do
        put :update_dashboard, params: { dash: dash_settings }
        expect(response.code).to eql('200')
      end

      it 'returns the dashboard items as JSON' do
        put :update_dashboard, params: { dash: dash_settings }

        parsed = JSON.parse(response.body)
        expect(parsed['dashboard_items']).to eql(dashboard_items.map(&:as_json))
      end

      it 'should return HTML with which to replace the dashboard' do
        put :update_dashboard, params: { dash: dash_settings }
        expect(JSON.parse(response.body)).to have_key('html')
      end

      it 'should set the preferences in the session' do
        put :update_dashboard, params: { dash: dash_settings }
        expect(session[:dashboard]).to eql(dash_settings.values)
      end
    end

    # ------------------------------------------------------------------------

    context 'when no setting hash is provided' do
      it 'should return a 400 Bad Request' do
        put :update_dashboard
        expect(response.status).to eql(400)
      end
    end

    # ------------------------------------------------------------------------

    context 'when the setting option is not a hash' do
      it 'should return a 400 Bad Request' do
        put :update_dashboard, params: { dash: 'invalid' }
        expect(response.status).to eql(400)
      end
    end

    # ------------------------------------------------------------------------

    context 'when given extra options' do
      it 'should not set extra keys on the session' do
        put :update_dashboard, params: {
          dash: dash_settings.merge(another: dashboard_items[0].key)
        }

        expect(session[:dashboard]).to eql(dash_settings.values)
      end
    end

    # ------------------------------------------------------------------------

    context 'when given only a subset of options' do
      it 'should not accept partial assignment' do
        put :update_dashboard, params: { dash: {
          DashboardItem::GROUPS[0] => dashboard_items[0].key,
          DashboardItem::GROUPS[1] => dashboard_items[1].key
        } }

        expect(response.status).to eql(400)
      end
    end

    # ------------------------------------------------------------------------

    context 'when given an invalid dashboard item ID' do
      it 'should return a 400 Bad Request' do
        put :update_dashboard, params: {
          dash: dash_settings.merge(DashboardItem::GROUPS[0] => 0)
        }

        expect(response.status).to eql(400)
      end
    end

    # ------------------------------------------------------------------------

  end
end
