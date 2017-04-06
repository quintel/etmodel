require 'rails_helper'

describe OutputElementsController, 'routing' do
  it 'routes GET /output_elements/1' do
    expect(get('/output_elements/1')).
      to route_to('output_elements#show', id: '1')
  end

  it 'routes GET /output_elements/batch/1' do
    expect(get('/output_elements/batch/1')).
      to route_to('output_elements#batch', ids: '1')
  end

  it 'routes GET /output_elements/batch/1,1,2' do
    expect(get('/output_elements/batch/1,1,2')).
      to route_to('output_elements#batch', ids: '1,1,2')
  end
end
