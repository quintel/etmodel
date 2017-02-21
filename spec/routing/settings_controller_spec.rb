require 'spec_helper'

describe SettingsController, 'routing' do
  it 'routes to GET /settings/dashboard' do
    expect(get('/settings/dashboard')).to route_to('settings#dashboard')
  end

  it 'routes to PUT /settings/dashboard' do
    expect(put('/settings/dashboard')).to route_to('settings#update_dashboard')
  end
end
