require 'spec_helper'

describe SettingsController, 'routing', type: :routing do
  it 'routes to GET /settings/dashboard' do
    get('/settings/dashboard').should route_to('settings#dashboard')
  end

  it 'routes to PUT /settings/dashboard' do
    put('/settings/dashboard').should route_to('settings#update_dashboard')
  end
end
