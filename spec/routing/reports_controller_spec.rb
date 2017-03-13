require 'rails_helper'

describe ReportsController, 'routing' do
  it 'does not route GET /scenario/reports' do
    expect(get('/scenario/reports')).to_not route_to('reports#show')
  end

  it 'routes GET /scenario/reports/main' do
    expect(get('/scenario/reports/main'))
      .to route_to('reports#show', id: 'main')
  end

  it 'routes to GET /scenario/reports/main-again' do
    expect(get('/scenario/reports/main-again'))
      .to route_to('reports#show', id: 'main-again')
  end

  it 'routes to GET /scenario/reports/main-2017' do
    expect(get('/scenario/reports/main-2017'))
      .to route_to('reports#show', id: 'main-2017')
  end

  it 'routes to GET /scenario/reports/./main' do
    expect(get('/scenario/reports/./main')).not_to be_routable
  end

  it 'routes to GET /scenario/reports/..main' do
    expect(get('/scenario/reports/..main')).not_to be_routable
  end

  it 'routes to GET /scenario/reports/..main/no' do
    expect(get('/scenario/reports/..main/no')).not_to be_routable
  end

  it 'routes to GET /scenario/reports/main..' do
    expect(get('/scenario/reports/main..')).not_to be_routable
  end
end
